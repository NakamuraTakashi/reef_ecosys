
!!!=== Copyright (c) 2025 Takashi NAKAMURA  =====

#include "cppdefs.h"


!!!*************** BIVALVE MODEL *****************************************


MODULE mod_bivalve
#ifdef BIVALVE
  implicit none

  TYPE T_BIVALVE
    real(8), pointer :: dens(:,:,:,:) 
    real(8), pointer :: QCs(:,:,:,:,:)
    real(8), pointer :: QCv(:,:,:,:,:)
    real(8), pointer :: QCr(:,:,:,:,:)
    real(8), pointer :: QCg(:,:,:,:,:)
    real(8), pointer :: QNs(:,:,:,:,:)
    real(8), pointer :: QNv(:,:,:,:,:)
    real(8), pointer :: QNr(:,:,:,:,:)
    real(8), pointer :: QNg(:,:,:,:,:)
    real(8), pointer :: QPs(:,:,:,:,:)
    real(8), pointer :: QPv(:,:,:,:,:)
    real(8), pointer :: QPr(:,:,:,:,:)
    real(8), pointer :: QPg(:,:,:,:,:)
    real(8), pointer :: CaCO3(:,:,:,:,:)
    real(8), pointer :: Dead_CaCO3(:,:,:,:,:)
    real(8), pointer :: R   (:,:,:,:) 
    real(8), pointer :: V   (:,:,:,:) 
    real(8), pointer :: L   (:,:,:,:) 
    real(8), pointer :: DW  (:,:,:,:) 
  END TYPE T_BIVALVE
  TYPE (T_BIVALVE), allocatable :: BIVALVE(:)
CONTAINS


!!! **********************************************************************
!!!  set initial conditions for the bivalve model
!!! **********************************************************************

  SUBROUTINE allocate_bivalve(ng, Ngrids, Nz, LBi, UBi, LBj, UBj)
    USE mod_reef_ecosys_param
    
    implicit none
    integer, intent(in) :: ng, Ngrids, Nz, LBi, UBi, LBj, UBj

    IF (ng.eq.1) allocate ( BIVALVE(Ngrids) )
    allocate( BIVALVE(ng)%dens    (Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QCs(N_Csp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QCv(N_Csp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QCr(N_Csp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QCg(N_Csp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QNs(N_Nsp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QNv(N_Nsp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QNr(N_Nsp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QNg(N_Nsp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QPs(N_Psp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QPv(N_Psp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QPr(N_Psp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%QPg(N_Psp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%CaCO3(N_Csp,Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%Dead_CaCO3(N_Csp,Nbv,Nz,LBi:UBi,LBj:UBj) )

    allocate( BIVALVE(ng)%R       (Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%V       (Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%L       (Nbv,Nz,LBi:UBi,LBj:UBj) )
    allocate( BIVALVE(ng)%DW      (Nbv,Nz,LBi:UBi,LBj:UBj) )

    RETURN

  END SUBROUTINE allocate_bivalve


!!! **********************************************************************
!!!  set initial conditions for the bivalve model
!!! **********************************************************************

  SUBROUTINE initialize_bivalve(ng, Nz, z_w, LBi, UBi, LBj, UBj, dens_aqua, start_of_new_run)
    USE mod_reef_ecosys_param
    USE mod_aquaculture
    USE mod_deb_model
    
    implicit none
! input parameters
    integer, intent(in) :: ng, Nz, LBi, UBi, LBj, UBj
    real(8), intent(in) :: z_w(0:Nz)
    real(8), intent(in) :: dens_aqua(LBi:UBi,LBj:UBj)     ! Density of oyster aquaculture (rope m-3)
    logical, intent(in) :: start_of_new_run               ! TRUE = initialize; FALSE = continue from previous run
    real(8) :: R13C
    integer :: i,j,m

!------------------------------------------
!  Set initial conditions
!   analytical start
    if( start_of_new_run ) then
     do j=LBj,UBj
       do i=LBi,UBi
         do k=1,Nz
           do n=1,Nbv
             BIVALVE(ng)%dens(n,k,i,j) = 0.0d0
             BIVALVE(ng)%R   (n,k,i,j) = 0.0d0
             BIVALVE(ng)%V   (n,k,i,j) = 0.0d0
             BIVALVE(ng)%L   (n,k,i,j) = 0.0d0
             BIVALVE(ng)%DW  (n,k,i,j) = 0.0d0
 
             BIVALVE(ng)%QCs(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QCv(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QCr(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QCg(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QNs(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QNv(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QNr(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QNg(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QPs(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QPv(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QPr(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%QPg(:,n,k,i,j) = 0.0d0
             BIVALVE(ng)%CaCO3(:,n,k,i,j) = 0.0d0  ! CaCO3 in living bivalve (mmol ind.-1)
             BIVALVE(ng)%Dead_CaCO3(:,n,k,i,j) = 0.0d0  ! CaCO3 in dead bivalve (mmol m-3)
             
             ! initialize for each bivalve group
             if (n.eq.iOys) then ! 01: Oyster
               BIVALVE(ng)%dens(n,k,i,j) =           &
                 dens_oyster_Shizugawa(dens_aqua(i,j), Nz, k, z_w)   ! Initial bivalve density (ind. m-3)
               !--- Total dry weight (g) (mmolC -> g(dw)) -----------------
               BIVALVE(ng)%DW(k,n,i,j)      = 1.0d3  ! g(dw) individual-1

               BIVALVE(ng)%QCv(iCt,n,k,i,j) = BIVALVE(ng)%DW(k,n,i,j)/25.22d0 * 1.0d-3 *0.8d0! mmolC individual-1
               BIVALVE(ng)%QCs(iCt,n,k,i,j) = BIVALVE(ng)%QCv(iCt,n,k,i,j) *0.2d0  ! mmolC individual-1
               BIVALVE(ng)%QCr(iCt,n,k,i,j) = 0.0d0 ! mmolC individual-1
               BIVALVE(ng)%QCg(iCt,n,k,i,j) = 0.0d0 ! mmolC individual-1
               BIVALVE(ng)%QNv(iNt,n,k,i,j) = BIVALVE(ng)%QCv(iCt,n,k,i,j)*16.0d0/106.0d0  ! mmolN individual-1
               BIVALVE(ng)%QNs(iNt,n,k,i,j) = BIVALVE(ng)%QCs(iCt,n,k,i,j)*16.0d0/106.0d0  ! mmolN individual-1
               BIVALVE(ng)%QNr(iNt,n,k,i,j) = BIVALVE(ng)%QCr(iCt,n,k,i,j)*16.0d0/106.0d0  ! mmolN individual-1
               BIVALVE(ng)%QNg(iNt,n,k,i,j) = BIVALVE(ng)%QCg(iCt,n,k,i,j)*16.0d0/106.0d0  ! mmolN individual-1
               BIVALVE(ng)%QPv(iPt,n,k,i,j) = BIVALVE(ng)%QCv(iCt,n,k,i,j)* 1.0d0/106.0d0  ! mmolP individual-1
               BIVALVE(ng)%QPs(iPt,n,k,i,j) = BIVALVE(ng)%QCs(iCt,n,k,i,j)* 1.0d0/106.0d0  ! mmolP individual-1
               BIVALVE(ng)%QPr(iPt,n,k,i,j) = BIVALVE(ng)%QCr(iCt,n,k,i,j)* 1.0d0/106.0d0  ! mmolP individual-1
               BIVALVE(ng)%QPg(iPt,n,k,i,j) = BIVALVE(ng)%QCg(iCt,n,k,i,j)* 1.0d0/106.0d0  ! mmolP individual-1
               !--- Body Volume (cm3) (g(dw) -> cm3)-----------------
               BIVALVE(ng)%V(k,n,i,j) = BIVALVE(ng)%DW(k,n,i,j) / 0.2d0 !d_v(n)=0.2  ! g(dw) -> cm3
               !--- Length (cm) (cm3 -> cm)-----------------
               BIVALVE(ng)%L(k,n,i,j) = V2L( BIVALVE(ng)%V(k,n,i,j), delta_M(m) ) 

             end if
 
           enddo
         enddo
       enddo
     enddo
    end if
    
    RETURN
      
  END SUBROUTINE initialize_bivalve

!!! **********************************************************************
!!!  Main program of the bivalve model
!!! **********************************************************************

  SUBROUTINE bivalve  &
!   input parameters
    ( ng, n, i, j, k &   ! ng: nested grid number; n: bivalve compartment; i,j,k: position
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
    USE mod_deb_model
    
    implicit none

! input parameters
    integer, intent(in) :: ng, n, i, j, k   ! ng: nested grid number; n: bivalve compartment; i,j,k: position
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

! --- C:N:P:CaCO3 ratio of bivalves ---
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

! --- Dynamic Energy Budget (DEB) model parameters ---
    real(8), parameter :: delta_M(1) = [   0.175d0] ! (no dim.)      Shape parameter (Van der Veer et al., 2006)
    real(8), parameter :: w2M(1)     = [   25.22d0] ! (g(dw) molC−1) Bivalve reserves/structure relative molecular mass (Saraiva et al., 2012)
    real(8), parameter :: d_v(1)     = [    0.2d0 ] ! (g(dw) cm−3)   Bivalve structure and reserve specific density (Rosland et al., 2009; Brey, 2001)
    real(8), parameter :: Tref(1)    = [  293.15d0] ! (K) Refernce temperature
    real(8), parameter :: T_A(1)     = [ 5800.0d0 ] ! (K) Arrhenius temperature (Van der Veer et al., 2006)
!    real(8), parameter :: T_H(1)     = [  305.0d0 ] ! (K) Upper boundary tolerance range (Van der Veer et al., 2006)
    real(8), parameter :: T_Hing(1)  = [  298.0d0 ] ! (K) Upper boundary tolerance range for ingestion (Bourles et al., 2009)
    real(8), parameter :: T_Hresp(1) = [  305.0d0 ] ! (K) Upper boundary tolerance range for respiration (Bourles et al., 2009)
    real(8), parameter :: T_AH(1)    = [30000.0d0 ] ! (K) Arrhenius temp. for upper boundary (Van der Veer et al., 2006)
!    real(8), parameter :: T_L(1)     = [  281.0d0 ] ! (K) Lower boundary tolerance range (Van der Veer et al., 2006)
    real(8), parameter :: T_L(1)     = [  276.0d0 ] ! (K) Lower boundary tolerance range (Bourles et al., 2009)
    real(8), parameter :: T_AL(1)    = [75000.0d0 ] ! (K) Arrhenius temp. for lower boundary (Van der Veer et al., 2006)
  ! --- Photoplankton ingestion parameters ---
    ! Maximum surface area specific clearance rate (L s-1 cm-2)
    !  0.096 (m3 d−1 cm−2), Saraiva et al. (2011b)
    real(8), parameter :: C_Rmax  (4,1) = reshape( [ 1.0d-6,    1.0d-6,    1.0d-8 ,    1.0d-8    ], [4,1] ) ! to Oyster
    ! Maximum surface area specific filtration rate (umol s−1 cm−2)
    !  4.8d-4 (molC d−1 cm−2), Rosland et al. (2009)
    real(8), parameter :: J_XiFmax(4,1) = reshape( [ 0.0693d0,  0.0693d0,  0.0693d0,   0.0693d0  ], [4,1] ) ! to Oyster
    ! Algal binding probability (no dim.)
    !  0.4 (no dim.),  Saraiva et al. (2011a)
    real(8), parameter :: rho_XiI (4,1) = reshape( [ 0.4d0, 0.4d0, 0.4d0, 0.4d0 ], [4,1] ) ! to Oyster
    ! Algal maximum ingestion rate (umol s−1)
    !  1.3d4 (molC d-1), Saraiva et al. (2011a)
    real(8), parameter :: J_XiImax(4,1) = reshape( [ 0.15d0,    0.15d0,    0.15d0,     0.15d0    ], [4,1] ) ! to Oyster

    real(8) :: kT  ! Temperature correction factor (no dimension)
    real(8) :: C_R ! Clearance rate (m3 d−1)
    real(8) :: V   ! Body Volume (cm3)
    real(8) :: J_XiF(Nphy) ! Filtration rate (umol s−1)
    real(8) :: J_XiI(Nphy) ! Ingestion rate (umol s−1)

    real(8) :: rQCs(N_Csp),rQCv(N_Csp),rQCr(N_Csp),rQCg(N_Csp)
    real(8) :: rQNs(N_Nsp),rQNv(N_Nsp),rQNr(N_Nsp),rQNg(N_Nsp)
    real(8) :: rQPs(N_Psp),rQPv(N_Psp),rQPr(N_Psp),rQPg(N_Psp)
    real(8) :: rPhyC(N_Csp,Nphy)
    real(8) :: rPhyN(N_Nsp,Nphy)
    real(8) :: rPhyP(N_Psp,Nphy)
    real(8) :: Gc,Gn,Gp
    real(8) :: cDOx
    real(8) :: cPhyC(Nphy),cPhyN(Nphy),cPhyP(Nphy)


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
      rQCs(isp) = Iso_ratio( BIVALVE(ng)%QCs(isp,k,n,i,j), BIVALVE(ng)%QCs(iCt,k,n,i,j) ) ! BIVALVE(ng)%QC
      rQCv(isp) = Iso_ratio( BIVALVE(ng)%QCv(isp,k,n,i,j), BIVALVE(ng)%QCv(iCt,k,n,i,j) ) ! BIVALVE(ng)%QC
      rQCr(isp) = Iso_ratio( BIVALVE(ng)%QCr(isp,k,n,i,j), BIVALVE(ng)%QCr(iCt,k,n,i,j) ) ! BIVALVE(ng)%QC
      rQCg(isp) = Iso_ratio( BIVALVE(ng)%QCg(isp,k,n,i,j), BIVALVE(ng)%QCg(iCt,k,n,i,j) ) ! BIVALVE(ng)%QC
      DO m=1,Nphy
        rPhyC(isp,m) = Iso_ratio( PhyC(isp,m), PhyC(iCt,m) ) ! PhyC
      END DO
    END DO
!--- Nitrogen isotope or tracer ratio (R15N = 15N/Nt) -----------------
    DO isp=1,N_Nsp
      rQNs(isp) = Iso_ratio( BIVALVE(ng)%QNs(isp,k,n,i,j), BIVALVE(ng)%QNs(iNt,k,n,i,j) ) ! BIVALVE(ng)%QN
      rQNv(isp) = Iso_ratio( BIVALVE(ng)%QNv(isp,k,n,i,j), BIVALVE(ng)%QNv(iNt,k,n,i,j) ) ! BIVALVE(ng)%QN
      rQNr(isp) = Iso_ratio( BIVALVE(ng)%QNr(isp,k,n,i,j), BIVALVE(ng)%QNr(iNt,k,n,i,j) ) ! BIVALVE(ng)%QN
      rQNg(isp) = Iso_ratio( BIVALVE(ng)%QNg(isp,k,n,i,j), BIVALVE(ng)%QNg(iNt,k,n,i,j) ) ! BIVALVE(ng)%QN
      DO m=1,Nphy
        rPhyN(isp,m) = Iso_ratio( PhyN(isp,m), PhyN(iCt,m) ) ! PhyN
      END DO
    END DO
!--- Phosphrous tracer ratio (RP = P1/Pt) -----------------
    DO isp=1,N_Psp
      rQPs(isp) = Iso_ratio( BIVALVE(ng)%QPs(isp,k,n,i,j), BIVALVE(ng)%QPs(iPt,k,n,i,j) ) ! BIVALVE(ng)%QP
      rQPv(isp) = Iso_ratio( BIVALVE(ng)%QPv(isp,k,n,i,j), BIVALVE(ng)%QPv(iPt,k,n,i,j) ) ! BIVALVE(ng)%QP
      rQPr(isp) = Iso_ratio( BIVALVE(ng)%QPr(isp,k,n,i,j), BIVALVE(ng)%QPr(iPt,k,n,i,j) ) ! BIVALVE(ng)%QP
      rQPg(isp) = Iso_ratio( BIVALVE(ng)%QPg(isp,k,n,i,j), BIVALVE(ng)%QPg(iPt,k,n,i,j) ) ! BIVALVE(ng)%QP
      DO m=1,Nphy
        rPhyP(isp,m) = Iso_ratio( PhyP(isp,m), PhyP(iPt,m) ) ! PhyP
      END DO
    END DO


    cDOx = MAX(DOx,0.0d0) !!! Error handling
    DO m=1,Nphy
      cPhyC(m) = MAX(PhyC(iCt,m),0.0d0) !!! Error handling
      cPhyN(m) = MAX(PhyN(iNt,m),0.0d0) !!! Error handling
      cPhyP(m) = MAX(PhyP(iPt,m),0.0d0) !!! Error handling
    END DO

!--- Total dry weight (g) (mmolC -> g(dw)) -----------------
    BIVALVE(ng)%DW(k,n,i,j) = (  BIVALVE(ng)%QCs(iCt,k,n,i,j) + BIVALVE(ng)%QCv(iCt,k,n,i,j)    &
                               + BIVALVE(ng)%QCr(iCt,k,n,i,j) + BIVALVE(ng)%QCg(iCt,k,n,i,j) )  &
                              * w2M(n) * 1.0d3  ! mmolC -> g(dw)  !!!!! Check the conversion factor !!!!!!
!--- Body Volume (cm3) (g(dw) -> cm3)-----------------
    BIVALVE(ng)%V(k,n,i,j) = BIVALVE(ng)%DW(k,n,i,j) / d_v(n)  ! g(dw) -> cm3
!--- Length (cm) (cm3 -> cm)-----------------
    BIVALVE(ng)%L(k,n,i,j) = V2L( BIVALVE(ng)%V(k,n,i,j), delta_M(m) ) 

! === Maximum respiration rate (mmol O2 ind.-1) =========================
    ! Temperature correction factor for respiration (no dimension)
    kT = tempcorr(Tmp+273.15d0, Tref(n), T_A(n), T_Hresp(n), T_AH(n), T_L(n), T_AL(n))
    ! Clearance rate (L s-1)
    CALL clearance_rate(Nphy, cPhyC, V, kT, C_Rmax(1:Nphy,n), J_XiFmax(1:Nphy,n) c2e, C_R, J_Rc)



! === Phtoplankton ingestion Rate (umolC s−1 ind.-1) =========================

    ! Temperature correction factor for ingestion (no dimension)
    kT = tempcorr(Tmp+273.15d0, Tref(n), T_A(n), T_Hing(n), T_AH(n), T_L(n), T_AL(n))
    ! Filtration rate (umol s−1)
!    CALL filtration_rate(Nphy, cPhyC, V, kT, C_Rmax(1:Nphy,n), J_XiFmax(1:Nphy,n), J_XiF)
    ! Ingestion rate (umol s−1)
    CALL ingestion_rate(Nphy, cPhyC, J_XiF, rho_XiI(1:Nphy,n), J_XiImax(1:Nphy,n), J_XiI)

! === Assimilation rate (umolC s−1 ind.-1) =========================

!     === Mass balance ===
    DO m=1,Nphy
      Gc = J_XiI(m)
      Gn = Gc*cPhyN(m)/cPhyC(m)
      Gp = Gc*cPhyP(m)/cPhyC(m)
      
      dPhyC_dt(:,m)    = dPhyC_dt(:,m)    - Gc*rPhyC(:,m)
      dPOC_dt(:,iLPOM) = dPOC_dt(:,iLPOM) + Mp* rLPOMphy              *rPhyC(:,k)
      dPOC_dt(:,iRPOM) = dPOC_dt(:,iRPOM) + Mp*(1d0-rLPOMphy)         *rPhyC(:,k)
      BIVALVE(ng)%QC(:,k,n,i,j) = BIVALVE(ng)%QC(:,k,n,i,j) + Gc*rPhyC(:,m) *dt

      dPhyN_dt(:,m)    = dPhyN_dt(:,m)    - Gn*rPhyN(:,m)
      dPON_dt(:,iLPOM) = dPON_dt(:,iLPOM) + Mp* rLPOMphy              *rPhyC(:,k)
      dPON_dt(:,iRPOM) = dPON_dt(:,iRPOM) + Mp*(1d0-rLPOMphy)         *rPhyC(:,k)
      BIVALVE(ng)%QN(:,k,n,i,j) = BIVALVE(ng)%QN(:,k,n,i,j) + Gn*rPhyN(:,m) *dt

      dPhyP_dt(:,m)    = dPhyP_dt(:,m)    - Gp*rPhyP(:,m)
      dPOP_dt(:,iLPOM) = dPOP_dt(:,iLPOM) + Mp* rLPOMphy              *rPhyC(:,k)
      dPOP_dt(:,iRPOM) = dPOP_dt(:,iRPOM) + Mp*(1d0-rLPOMphy)         *rPhyC(:,k)
      BIVALVE(ng)%QP(:,k,n,i,j) = BIVALVE(ng)%QP(:,k,n,i,j) + Gp*rPhyP(:,m) *dt
     
    END DO

! === Oyster's oxygen demand (mmol O2 ind.-1) =========================

! === Calcification rate (mmol C ind.-1) =========================


! === Mortality rate (ind. s-1) =========================

    RETURN
  
  END SUBROUTINE bivalve
#endif
END MODULE mod_bivalve

