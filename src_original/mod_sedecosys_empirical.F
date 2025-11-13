!!!=== Copyright (c) 2013-2025 Takashi NAKAMURA  =====!!!
!!!         - Tokyo Institute of Technology -         !!!
!!!                                                   !!!
!!!          Sediment Biogeochemical Module           !!!
!!!            Developed by Masa Muto 2023-           !!!
!!!===================================================!!!
 
#include "cppdefs.h"

!!!**** MODULE OF SEDIMENT ECOSYSTEM MODEL ************************************
!!! **********************************************************************
!!!  Empirical sediment model
!!! **********************************************************************
MODULE mod_sedecosys_empirical
#if defined SEDIMENT_ECOSYS && defined SEDIMENT_EMPIRICAL
  implicit none
  TYPE T_SEDECO
    real(8), pointer :: Pg(:,:) 
    real(8), pointer :: R (:,:) 
    real(8), pointer :: G (:,:) 
    real(8), pointer :: QC(:,:)
# if defined CARBON_ISOTOPE
!  13C isotope
    real(8), pointer :: Q13C(:,:)
# endif
# if defined NUTRIENTS         
    real(8), pointer :: QN(:,:)
    real(8), pointer :: QP(:,:)
# endif
  END TYPE T_SEDECO
  TYPE (T_SEDECO), allocatable :: SEDECO(:)
CONTAINS

!!! **********************************************************************
!!!  set initial conditions for empirical sediment model
!!! **********************************************************************

  subroutine initialize_sedecosys(ng, Ngrids, LBi, UBi, LBj, UBj)
    USE mod_geochem
    
    implicit none
! input parameters
    integer, intent(in) :: ng, Ngrids, LBi, UBi, LBj, UBj
    real(8)  R13C
    integer i,j,n
    IF (ng.eq.1) allocate ( SEDECO(Ngrids) )
    allocate( SEDECO(ng)%Pg(LBi:UBi,LBj:UBj)     )
    allocate( SEDECO(ng)%R (LBi:UBi,LBj:UBj)     )
    allocate( SEDECO(ng)%G (LBi:UBi,LBj:UBj)     )
    allocate( SEDECO(ng)%QC(LBi:UBi,LBj:UBj)     )
# if defined CARBON_ISOTOPE
    allocate( SEDECO(ng)%Q13C(LBi:UBi,LBj:UBj)   )
# endif
# if defined NUTRIENTS         
    allocate( SEDECO(ng)%QN(LBi:UBi,LBj:UBj)     )
    allocate( SEDECO(ng)%QP(LBi:UBi,LBj:UBj)     )
# endif

!------------------------------------------
!  Set initial conditions
    do j=LBj,UBj
      do i=LBi,UBi
!      sediment internal conditions
        SEDECO(ng)%Pg(i,j) = 0.0d0
        SEDECO(ng)%R (i,j) = 0.0d0
        SEDECO(ng)%G (i,j) = 0.0d0
        SEDECO(ng)%QC(i,j) = 15.0d0  !!!tentative
# if defined CARBON_ISOTOPE
        R13C = R13C_fromd13C(-18.0d0)
!        c13CH2O (n,i,j)=R13C/(1.+R13C)*CH2O(n,i,j)
        SEDECO(ng)%Q13C(i,j) = R13C * SEDECO(ng)%QC(i,j)
# endif
# if defined NUTRIENTS         
        SEDECO(ng)%QN(i,j) = 1.5d0  !!!tentative
        SEDECO(ng)%QP(i,j) = 0.1d0  !!!tentative
# endif
      enddo
    enddo
    
    RETURN
    
  END SUBROUTINE initialize_sedecosys

!!! **********************************************************************
!!!  Main program of empirical sediment model
!!! **********************************************************************

  SUBROUTINE sedecosys &
!   input parameters
    ( ng, i, j       &   ! ng: nested grid number; i,j: position
    , PFD            &   ! Photon flux density (umol m-2 s-1)
    , rho_sw         &   ! Density of seawater (g cm-3)
    , DICamb         &   ! DIC (umol kg-1)
    , TAamb          &   ! TA (umol kg-1)
    , DOamb          &   ! DO (umol L-1)
# if defined NUTRIENTS         
    , NH4amb         &   ! NH4 concentration (umol L-1)
# endif
# if defined CARBON_ISOTOPE
    , DI13Camb       &   ! 13C of DIC (umol kg-1)
# endif
!   output parameters
    , DICuptake      &   ! DIC uptake rate (mmol m-2 s-1)  * direction of water column to coral is positive
    , TAuptake       &   ! DIC uptake rate (mmol m-2 s-1)  * direction of water column to coral is positive
    , DOuptake       &   ! DO  uptake rate (mmol m-2 s-1)  * direction of water column to coral is positive
# if defined NUTRIENTS         
    , NO3uptake      &   ! NO3 uptake rate (mmol m-2 s-1)  * direction of water column to coral is positive
    , NH4uptake      &   ! NH4 uptake rate (mmol m-2 s-1)  * direction of water column to coral is positive
    , PO4uptake      &   ! PO4 uptake rate (mmol m-2 s-1)  * direction of water column to coral is positive
# endif
# if defined CARBON_ISOTOPE
    , DI13Cuptake    &   ! DI13C uptake rate (mmol m-2 s-1)  * direction of water column to coral is positive
# endif
    )

!-----------------------------------------------------------------------
    USE mod_geochem
    
    implicit none

! input parameters
    integer, intent(in) :: ng, i, j    ! ng: nested grid number; i,j: position
    real(8), intent(in) :: PFD
    real(8), intent(in) :: rho_sw   
    real(8), intent(in) :: DICamb
    real(8), intent(in) :: TAamb
    real(8), intent(in) :: DOamb
# if defined NUTRIENTS         
    real(8), intent(in) :: NH4amb
# endif
# if defined CARBON_ISOTOPE
    real(8), intent(in) :: DI13Camb
# endif
! output parameters
    real(8), intent(out) :: DICuptake
    real(8), intent(out) :: TAuptake
    real(8), intent(out) :: DOuptake
# if defined NUTRIENTS         
    real(8), intent(out) :: NO3uptake
    real(8), intent(out) :: NH4uptake
    real(8), intent(out) :: PO4uptake
# endif
# if defined CARBON_ISOTOPE
    real(8), intent(out) :: DI13Cuptake
# endif

! --- C:N:P ratio of seagrass ---
    real(8), parameter :: nc=27./599.d0 !M.J.Atkinson and SV Smith(1983)
    real(8), parameter :: pc=1./599.d0
! --- Photosynthesis and Calcification Parameters ---
!    real(8), parameter :: pmax =  5.02d0 ! Nakamura & Nakamori 2009
!    real(8), parameter :: pIk  = 1040.5d0
!    real(8), parameter :: p0   =  2.46d0
!    real(8), parameter :: gmax =  4.28d0 ! Nakamura & Nakamori 2009
!    real(8), parameter :: gIk  = 3507.87d0
!    real(8), parameter :: g0   =  0.61d0
    real(8), parameter :: p1 = 3.188d-3 ! Nakamura & Nakamori 2009
    real(8), parameter :: p0 = 2.369d0  !  Model skill = 0.968
    real(8), parameter :: g1 = 1.193d-3 ! Nakamura & Nakamori 2009
    real(8), parameter :: g0 = 0.6267d0 !  Model skill = 0.981
# if defined NUTRIENTS         
    real(8) npref
    real(8) ldocn,ldocd
# endif
# if defined CARBON_ISOTOPE
    real(8), parameter :: aC_phot  = -20.0d-3+1.d0  ! -5 to -10 per mill (Dr. Miyajima, pers. comn.)
    real(8), parameter :: aC_resp  =  0.0d-3+1.d0  !
    real(8), parameter :: aC_calc =   2.7d-3 + 1.0d0 
    real(8), parameter :: a_diss =   0.0d-3 + 1.0d0 
    real(8) R13C_DIC, R13C_QC, R13C_CaCO3
# endif

! --- Organic and Inorganic Production Rate -----------------

!    SEDECO(ng)%Pg(i,j)= pmax*tanh(PFD/pIk)/3600.d0   !Light response curve [mmolC/m2/s]
!    SEDECO(ng)%R (i,j)= p0/3600.d0   !Constant [mmolC/m2/s]
!    SEDECO(ng)%G (i,j)= (gmax*tanh(PFD/gIk)-g0)/3600.d0   !Light response curve [mmolC/m2/s]
    SEDECO(ng)%Pg(i,j)= p1*PFD/3600.d0   !Light response curve [mmolC/m2/s]
    SEDECO(ng)%R (i,j)= p0/3600.d0   !Constant [mmolC/m2/s]
    SEDECO(ng)%G (i,j)= (g1*PFD-g0)/3600.d0   !Light response curve [mmolC/m2/s]
    
    IF(DICamb<=0.d0) THEN !-----For Error handling
      SEDECO(ng)%Pg(i,j) = 0.d0
    ENDIF
    IF(TAamb<=0.d0) THEN !-----For Error handling
      SEDECO(ng)%G (i,j) = 0.d0
    ENDIF
    IF(DOamb<=0.d0) THEN !-----For Error handling
      SEDECO(ng)%R (i,j) = 0.d0
    ENDIF
    
    DICuptake= SEDECO(ng)%Pg(i,j)+SEDECO(ng)%G (i,j)-SEDECO(ng)%R (i,j)
    TAuptake = 2.0d0*SEDECO(ng)%G (i,j)
    DOuptake = SEDECO(ng)%R (i,j)-SEDECO(ng)%Pg(i,j)

!!! ----- Isotope calculation (Not implemented yet!!!) ----------
# if defined CARBON_ISOTOPE
    R13C_DIC  = DI13Camb/DICamb
    R13C_QC = SEDECO(ng)%Q13C(i,j) / SEDECO(ng)%QC(i,j)
    R13C_CaCO3 = R13C_fromd13C(-3.0d0) 
    
    IF(DI13Camb<=0.d0) THEN !-----For Error handling
      R13C_DIC =0.d0
    ENDIF

    DI13Cuptake=  SEDECO(ng)%Pg(i,j)*R13C_DIC*aC_phot                   &
                + max(SEDECO(ng)%G (i,j),0.0d0)*R13C_DIC*aC_calc        &
                + min(SEDECO(ng)%G (i,j),0.0d0)*R13C_CaCO3*a_diss      &
                - SEDECO(ng)%R (i,j)*R13C_QC*aC_resp
# endif
      
! --- Nutrient fluxes between water column and coral -----
# if defined NUTRIENTS         
!!! Under develping
    NO3uptake = 0.0d0
    NH4uptake = 0.0d0
    PO4uptake = 0.0d0
# endif
    RETURN
    
  END SUBROUTINE sedecosys
#endif
END MODULE mod_sedecosys_empirical
