
!!!=== Copyright (c) 2025 Takashi NAKAMURA  =====

#include "cppdefs.h"


!!!*************** OYSTER MODEL *****************************************


MODULE mod_oyster
#ifdef OYSTER
  implicit none

  TYPE T_OYSTER
    real(8), pointer :: dens(:,:,:,:) 
    real(8), pointer :: QC(:,:,:,:,:)
    real(8), pointer :: QN(:,:,:,:,:)
    real(8), pointer :: QP(:,:,:,:,:)
    real(8), pointer :: CaCO3(:,:,:,:,:)
    real(8), pointer :: Dead_CaCO3(:,:,:,:,:)
    real(8), pointer :: R   (:,:,:,:) 
  END TYPE T_OYSTER
  TYPE (T_OYSTER), allocatable :: OYSTER(:)
CONTAINS


!!! **********************************************************************
!!!  set initial conditions for the oyster model
!!! **********************************************************************

  SUBROUTINE allocate_oyster(ng, Ngrids, Nz, LBi, UBi, LBj, UBj)
    USE mod_reef_ecosys_param
    
    implicit none
    integer, intent(in) :: ng, Ngrids, Nz, LBi, UBi, LBj, UBj

    IF (ng.eq.1) allocate ( OYSTER(Ngrids) )
    allocate( OYSTER(ng)%dens    (Noy,Nz,LBi:UBi,LBj:UBj) )
    allocate( OYSTER(ng)%QC(N_Csp,Noy,Nz,LBi:UBi,LBj:UBj) )
    allocate( OYSTER(ng)%QN(N_Nsp,Noy,Nz,LBi:UBi,LBj:UBj) )
    allocate( OYSTER(ng)%QP(N_Psp,Noy,Nz,LBi:UBi,LBj:UBj) )
    allocate( OYSTER(ng)%CaCO3(N_Csp,Noy,Nz,LBi:UBi,LBj:UBj) )
    allocate( OYSTER(ng)%Dead_CaCO3(N_Csp,Noy,Nz,LBi:UBi,LBj:UBj) )


    allocate( OYSTER(ng)%R       (Noy,Nz,LBi:UBi,LBj:UBj) )

    RETURN

  END SUBROUTINE allocate_oyster


!!! **********************************************************************
!!!  set initial conditions for the oyster model
!!! **********************************************************************

  SUBROUTINE initialize_oyster(ng, Nz, dz, LBi, UBi, LBj, UBj)
    USE mod_reef_ecosys_param
    
    implicit none
! input parameters
    integer, intent(in) :: ng, Nz, LBi, UBi, LBj, UBj
    real(8), intent(in) :: dz(Nz)
    real(8) :: R13C
    integer :: i,j,n

!------------------------------------------
!  Set initial conditions
    do j=LBj,UBj
      do i=LBi,UBi
        do k=1,Nz
          do n=1,Noy
            OYSTER(ng)%dens(n,k,i,j) = 0.0d0
            OYSTER(ng)%R   (n,k,i,j) = 0.0d0

            OYSTER(ng)%QC(:,n,k,i,j) = 0.0d0
            OYSTER(ng)%QN(:,n,k,i,j) = 0.0d0
            OYSTER(ng)%QP(:,n,k,i,j) = 0.0d0
            OYSTER(ng)%CaCO3(:,n,k,i,j) = 0.0d0  ! CaCO3 in living oyster (mmol ind.-1)
            OYSTER(ng)%Dead_CaCO3(:,n,k,i,j) = 0.0d0  ! CaCO3 in dead oyster (mmol m-3)
            OYSTER(ng)%QC(iCt,n,i,j) = 15.0d0
            OYSTER(ng)%QN(iNt,n,i,j) = 1.5d0
            OYSTER(ng)%QP(iPt,n,i,j) = 0.1d0
          enddo
        enddo
      enddo
    enddo
    
    RETURN
      
  END SUBROUTINE initialize_oyster

!!! **********************************************************************
!!!  Main program of the oyster model
!!! **********************************************************************

  SUBROUTINE oyster  &
!   input parameters
    ( ng, n, i, j, k &   ! ng: nested grid number; n: oyster compartment; i,j,k: position
    , date           &   ! Date (days since x or elapsed days)
    , dt             &   ! Time step (sec)
    , rho_sw         &   ! Density of seawater (g cm-3)
    , Tmp            &   ! Temperature (oC)
    , Sal            &   ! Salinity (PSU)
    , DOx            &   ! DOx             : Dissolved oxygen (umol O2 L-1)
    , Wcal           &   ! Calcite saturation state
    , PhyC           &   ! Phytoplankton C bomass (umol C L-1)
    , PhyN           &   ! Phytoplankton N bomass (umol N L-1)
    , PhyP           &   ! Phytoplankton P bomass (umol P L-1)
!   output parameters
    , dDOx_dt        &   ! dDOx_dt             : dDOx/dt  (umol O2 L-1 s-1) 
    , dTA_dt         &   ! dTA_dt              : dTA/dt   (umol kg-1 s-1) 
    , dDIC_dt        &   ! dDIC_dt(N_Csp)      : dDIC/dt  (umol C kg-1 s-1)  1 mmol m-3 = 1 umol L-1 = 1/1.024 umol kg-1
    , dNH4_dt        &   ! dNH4_dt(N_Nsp)      : dNH4/dt  (umol N L-1 s-1)
    , dPO4_dt        &   ! dPO4_dt(N_Psp)      : dPO4/dt  (umol P L-1 s-1)
    , dDOC_dt        &   ! dDOC_dt(N_Csp,Ndom) : dDOC/dt  (umol C L-1 s-1) 
    , dPOC_dt        &   ! dPOC_dt(N_Csp,Npom) : dPOC/dt  (umol C L-1 s-1) 
    , dDON_dt        &   ! dDON_dt(N_Nsp,Ndom) : dDON/dt  (umol N L-1 s-1)
    , dPON_dt        &   ! dPON_dt(N_Nsp,Npom) : dPON/dt  (umol N L-1 s-1)
    , dDOP_dt        &   ! dDOP_dt(N_Psp,Ndom) : dDOP/dt  (umol P L-1 s-1)
    , dPOP_dt        &   ! dPOP_dt(N_Psp,Npom) : dPOP/dt  (umol P L-1 s-1)
    , dPhyC_dt       &   ! dPhyC_dt(N_Csp,Nphy): dPhyC/dt (umol C L-1 s-1)  
    , dPhyN_dt       &   ! dPhyN_dt(N_Nsp,Nphy): dPhyN/dt (umol N L-1 s-1)  
    , dPhyP_dt       &   ! dPhyP_dt(N_Psp,Nphy): dPhyP/dt (umol P L-1 s-1)  
!    , dPIC_dt        &   ! dPIC_dt (N_Csp,Npim): dPIC/dt  (umol C L-1 s-1)
    )

!-----------------------------------------------------------------------
    USE mod_reef_ecosys_param
    USE mod_geochem
    
    implicit none

! input parameters
    integer, intent(in) :: ng, n, i, j, k   ! ng: nested grid number; n: oyster compartment; i,j,k: position
    real(8), intent(in) :: date                 ! Date (days since x or elapsed days)
    real(8), intent(in) :: dt                   ! Time step (sec)
    real(8), intent(in) :: rho_sw               ! Density of seawater (g cm-3)
    real(8), intent(in) :: Tmp                  ! Temperature (oC)
    real(8), intent(in) :: Sal                  ! Salinity (PSU)
    real(8), intent(in) :: DOx                  ! Dissolved oxygen (umol L-1)
    real(8), intent(in) :: Wcal                 ! Calcite saturation state
    real(8), intent(in) :: PhyC(N_Csp,Nphy)     ! phytoplankton C biomass (umol C L-1), dinoflagellate
    real(8), intent(in) :: PhyN(N_Nsp,Nphy)     ! phytoplankton N biomass (umol N L-1), dinoflagellate
    real(8), intent(in) :: PhyP(N_Psp,Nphy)     ! phytoplankton P biomass (umol P L-1), dinoflagellate
! output parameters
    real(8), intent(out) :: dDOx_dt              ! dDOx/dt  (umol L-1 s-1) 
    real(8), intent(out) :: dTA_dt               ! dTA/dt   (umol kg-1 s-1) 
    real(8), intent(out) :: dDIC_dt(N_Csp)       ! dDIC/dt  (umol kg-1 s-1)  1 mmol m-3 = 1 umol L-1 = 1/1.024 umol kg-1
    real(8), intent(out) :: dNH4_dt(N_Nsp)       ! dNH4/dt (umol L-1 s-1)
    real(8), intent(out) :: dPO4_dt(N_Psp)       ! dPO4/dt (umol L-1 s-1)
    real(8), intent(out) :: dDOC_dt(N_Csp,Ndom)  ! dDOC/dt  (umol L-1 s-1) 
    real(8), intent(out) :: dPOC_dt(N_Csp,Npom)  ! dPOC/dt  (umol L-1 s-1) 
    real(8), intent(out) :: dDON_dt(N_Nsp,Ndom)  ! dDON/dt (umol L-1 s-1)
    real(8), intent(out) :: dPON_dt(N_Nsp,Npom)  ! dPON/dt (umol L-1 s-1)
    real(8), intent(out) :: dDOP_dt(N_Psp,Ndom)  ! dDOP/dt (umol L-1 s-1)
    real(8), intent(out) :: dPOP_dt(N_Psp,Npom)  ! dPOP/dt (umol L-1 s-1)
    real(8), intent(out) :: dPhyC_dt(N_Csp,Nphy) ! dPhyC/dt  (umolC L-1 s-1)  
    real(8), intent(out) :: dPhyN_dt(N_Nsp,Nphy) ! dPhyN/dt  (umolN L-1 s-1)  
    real(8), intent(out) :: dPhyP_dt(N_Psp,Nphy) ! dPhyP/dt  (umolP L-1 s-1)  
!    real(8), intent(out) :: dPIC_dt (N_Csp,Npim) ! dPIC/dt  (umol L-1 s-1) 

! --- C:N:P:CaCO3 ratio of oysters ---
    real(8), parameter :: rNC(1)  = [ 16d0/106d0 ] ! (no dim.) Oyster N:C ratio
    real(8), parameter :: rPC(1)  = [  1d0/106d0 ] ! (no dim.) Oyster P:C ratio
    real(8), parameter :: rCaC(1) = [      0.0d0 ]  ! ***** (no dim.) CaCO3:OrgC ratio !!! Need Ref!!!!!!!!!!
! --- Photoplankton ingestion parameters ---
    real(8), parameter :: k_G(4,1)   = reshape( [ 1.0d-6,    1.0d-6,    1.0d-8 ,    1.0d-8    ], [4,1] ) ! to Oyster1 (s-1)          Maximum grazing rate of PhyC1 by ZooC at 0 oC (0.3d0 d-1; Kawamiya et al., 1995)0.16
    real(8), parameter :: b_G(4,1)   = reshape( [ 0.0693d0,  0.0693d0,  0.0693d0,   0.0693d0  ], [4,1] ) ! to Oyster1 (degC-1)       Temperature coefficient for ZooC grazing (0.063d0degC-1;Kawamiya et al., 1995)
    real(8), parameter :: e_G(4,1)   = reshape( [ 0.15d0,    0.15d0,    0.15d0,     0.15d0    ], [4,1] ) ! to Oyster1 (no dim.)      Assimilation efficiency of ZooC (0.7:Kawamiya et al., 1995)
    real(8), parameter :: K_phy(4,1) = reshape( [ 1.0d0,     10.0d0,     0.1d0,      0.1d0     ], [4,1] ) ! (umol C L-1)       PhyC1 threshold value for grazing by ZooC (0.04umolN/L0.265; Kishi et al., 2007)

    real(8), parameter :: k_R(1) = [ 6.0d-8    ]  ! (s-1)            zooplankton respiration rate at 0  oC  																					!!!(Tuning) Check
    real(8), parameter :: b_R(1) = [ 0.0693d0  ]  ! (degC-1)         Temperature coefficient for ZooC respiration rate (Kawamiya et al., 1995)
    real(8), parameter :: k_M(1) = [ 5.0d-8    ]  ! (L umol-1 s-1)   zooplankton mortality rate at 0 oC 3.0d0/86400.0d0(0.0088d0 umol-1 d-1; Kawamiya et al., 1995)
    real(8), parameter :: b_M(1) = [ 0.0693d0  ]  ! (degC-1)         Temperature coefficient for ZooC mortality (Kawamiya et al., 1995)

    real(8) :: rQC(N_Csp),rPhyC(N_Csp,Nphy)
    real(8) :: rQN(N_Nsp),rPhyN(N_Nsp,Nphy)
    real(8) :: rQP(N_Psp),rPhyP(N_Psp,Nphy)
    real(8) :: Gc,Gn,Gp
    real(8) :: cPhyC,cPhyN,cPhyP

    integer :: isp, m

    dDOx_dt       = 0.0d0
    dTA_dt        = 0.0d0
    dDIC_dt(:)    = 0.0d0
    dNH4_dt(:)    = 0.0d0
    dPO4_dt(:)    = 0.0d0
    dDOC_dt(:,:)  = 0.0d0
    dPOC_dt(:,:)  = 0.0d0
    dDON_dt(:,:)  = 0.0d0
    dPON_dt(:,:)  = 0.0d0
    dDOP_dt(:,:)  = 0.0d0
    dPOP_dt(:,:)  = 0.0d0
    dPhyC_dt(:,:) = 0.0d0
    dPhyN_dt(:,:) = 0.0d0
    dPhyP_dt(:,:) = 0.0d0
!    dPIC_dt (:,:) = 0.0d0

!--- Carbon isotope or tracer ratio (R13C = 13C/Ct) -----------------
    DO isp=1,N_Csp
      rQC(isp) = Iso_ratio( OYSTER(ng)%QC(isp,k,n,i,j), OYSTER(ng)%QC(iCt,k,n,i,j) ) ! OYSTER(ng)%QC
      DO m=1,Nphy
        rPhyC(isp,m) = Iso_ratio( PhyC(isp,m), PhyC(iCt,m) ) ! PhyC
      END DO
    END DO
!--- Nitrogen isotope or tracer ratio (R15N = 15N/Nt) -----------------
    DO isp=1,N_Nsp
      rQN(isp) = Iso_ratio( OYSTER(ng)%QN(isp,k,n,i,j), OYSTER(ng)%QN(iNt,k,n,i,j) ) ! OYSTER(ng)%QN
      DO m=1,Nphy
        rPhyN(isp,m) = Iso_ratio( PhyN(isp,m), PhyN(iCt,m) ) ! PhyN
      END DO
    END DO
!--- Phosphrous tracer ratio (RP = P1/Pt) -----------------
    DO isp=1,N_Psp
      rQP(isp) = Iso_ratio( OYSTER(ng)%QP(isp,k,n,i,j), OYSTER(ng)%QP(iPt,k,n,i,j) ) ! OYSTER(ng)%QP
      DO m=1,Nphy
        rPhyP(isp,m) = Iso_ratio( PhyP(isp,m), PhyP(iPt,m) ) ! PhyP
      END DO
    END DO

! === Phtoplankton ingestion Rate (mmolC ind.-1) =========================
    DO m=1,Nphy
      cPhyC = MAX(PhyC(iCt,m),0.0d0) !!! Error handling
      cPhyN = MAX(PhyN(iNt,m),0.0d0) !!! Error handling
      cPhyP = MAX(PhyP(iPt,m),0.0d0) !!! Error handling

      Gc = k_G(m,k) * exp(b_G(m,k)*Tmp)    &
            * (cPhyC/(K_phy(m,k) + cPhyC)) * OYSTER(ng)%QC(iCt,k,n,i,j)
    END DO


    RETURN
  
  END SUBROUTINE oyster
#endif
END MODULE mod_oyster

