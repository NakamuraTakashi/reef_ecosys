
!!!=== Copyright (c) 2012-2025 Takashi NAKAMURA  =====

!--------------------------------------------------------------------------------
!
!  Parameter module
!
!--------------------------------------------------------------------------------

#include "cppdefs.h"

MODULE mod_param

  USE mod_reef_ecosys_param

  implicit none
!
!-----------------------------------------------------------------------
!  Grid nesting parameters.
!-----------------------------------------------------------------------

  real(8) :: time    !(day)
  
  real(8), allocatable :: swrad_data(:)
  real(8), allocatable :: swrad_time(:)
  real(8), allocatable :: dlwrad_data(:)
  real(8), allocatable :: dlwrad_time(:)
  real(8), allocatable :: Tair_data (:)
  real(8), allocatable :: Tair_time (:)
  real(8), allocatable :: Pair_data (:)
  real(8), allocatable :: Pair_time (:)
  real(8), allocatable :: Uwind_data(:)
  real(8), allocatable :: Vwind_data(:)
  real(8), allocatable :: wind_time (:)
  real(8), allocatable :: rain_data (:)
  real(8), allocatable :: rain_time (:)
  real(8), allocatable :: Rh_data   (:)
  real(8), allocatable :: Rh_time   (:)
  real(8), allocatable :: cloud_data(:)
  real(8), allocatable :: cloud_time(:)
  real(8) :: swrad
  real(8) :: dlwrad
  real(8) :: Tair
  real(8) :: Pair
  real(8) :: Uwind
  real(8) :: Vwind
  real(8) :: rain
  real(8) :: Rh
  real(8) :: cloud
  integer :: num_swrad
  integer :: num_dlwrad
  integer :: num_Tair
  integer :: num_Pair
  integer :: num_wind
  integer :: num_rain
  integer :: num_Rh
  integer :: num_cloud 
  
  real(8), allocatable :: PFD_time(:)
  real(8), allocatable :: PFD_data(:)
  real(8) :: PFD
  integer :: num_PFD
  real(8), allocatable :: wtemp_data(:)
  real(8), allocatable :: wtemp_time(:)
  real(8) :: wtemp
  integer :: num_wtemp
  
  real(8), allocatable :: tide_data(:)
  real(8), allocatable :: tide_time(:)
  real(8) :: tide
  integer :: num_tide
  
  real(8), allocatable :: wv_time(:)
  real(8), allocatable :: Hs_data(:)
  real(8), allocatable :: Tp_data(:)
  real(8) :: Hs
  real(8) :: Tp
  integer :: num_wv

  integer, parameter :: iswrad  = 1
  integer, parameter :: idlwrad = 2
  integer, parameter :: iTair   = 3
  integer, parameter :: iPair   = 4
  integer, parameter :: iwind   = 5
  integer, parameter :: irain   = 6
  integer, parameter :: iRh     = 7
  integer, parameter :: icloud  = 8
  integer, parameter :: iPFD    = 9
  integer, parameter :: iwtemp  = 10
  integer, parameter :: itide   = 11
  integer, parameter :: iwv     = 12

  integer :: id_swrad  = 1
  integer :: id_dlwrad = 1
  integer :: id_Tair   = 1
  integer :: id_Pair   = 1
  integer :: id_wind   = 1
  integer :: id_rain   = 1
  integer :: id_Rh     = 1
  integer :: id_cloud  = 1
  integer :: id_PFD    = 1
  integer :: id_wtemp  = 1
  integer :: id_tide   = 1
  integer :: id_wv     = 1


  real(8), allocatable :: WQ_time(:)
  real(8), allocatable :: TA_data(:)
  real(8), allocatable :: DIC_data(:)
  real(8), allocatable :: DO_data(:)
  integer :: N_WQ
  integer :: i_WQ = 1


  real(8) :: PFDsurf    
  real(8) :: tau        
  real(8) :: pCO2air    
  real(8) :: U10        
  
  real(8) :: ssfCO2    
  real(8) :: ssCO2flux 
  real(8) :: ssO2flux  
  real(8) :: PFDbott   

  real(8) :: fvol_cre      ! volume flux through the reef crest (m3 m-2 s-1)
  real(8) :: fvol_cha      ! volume flux through the channel(m3 m-2 s-1)
  real(8) :: fvol_pre      ! Precipitation volume flux (m s-1)
!  real(8) :: dw_lwradi     ! Downward longwave radiation (W m-2)
  real(8) :: ereef         ! sea surface elevation on the reef flat (m)
  real(8), parameter :: z_crest = -0.15d0 ! reef crest position (m)
  real(8), parameter :: kvol_cre   = 5.0d-2 ! reef crest conductivity
  real(8), parameter :: kvol_cha = 1.0d-1 ! Channel conductivety
  real(8) :: wave_setup   ! wave setup (m)

  integer :: iTemp                  ! Temperature
  integer :: iSalt                  ! Salinity
  integer :: iSedi                  ! suspended sediment

  integer :: idCrl1                 ! Coral coverage
  integer :: idCrl2                 ! Coral2 coverage
  integer :: idSgrs                 ! Seagrass coverage
  integer :: idAlga                 ! Algal coverage
  integer :: idSand                 ! Sand coverage
  
  integer :: idd13C                 ! d13C of DIC

  integer, allocatable :: idbio(:)  ! Biological tracers
  integer :: iOxyg                  ! Dissolved oxygen concentration
  integer :: iTAlk                  ! Total alkalinity
  integer :: iTIC(N_Csp)                  ! Total inorganic carbon
  integer :: iNO3(N_Nsp)                  ! Nitrate concentration
  integer :: iNH4(N_Nsp)                  ! Ammonium concentration
  integer :: iPO4(N_Psp)                  ! Ammonium concentration
  integer :: iDOC(N_Csp,Ndom)            ! Dissolved organic C-concentration
  integer :: iPOC(N_Csp,Npom)            ! Particulate organic C-concentration
  integer :: iDON(N_Nsp,Ndom)            ! Dissolved organic N-concentration
  integer :: iPON(N_Nsp,Npom)            ! Particulate organic N-concentration
  integer :: iDOP(N_Psp,Ndom)            ! Dissolved organic P-concentration
  integer :: iPOP(N_Psp,Npom)            ! Particulate organic P-concentration
  integer :: iPhyC(N_Csp,Nphy)          ! Phytoplankton1 density
  integer :: iZooC(N_Csp,Nzoo)          ! Zooplankton density
  integer :: iPhyN(N_Nsp,Nphy)          ! Phytoplankton1 density
  integer :: iZooN(N_Nsp,Nzoo)          ! Zooplankton density
  integer :: iPhyP(N_Psp,Nphy)          ! Phytoplankton1 density
  integer :: iZooP(N_Psp,Nzoo)          ! Zooplankton density
  integer :: iPIC(N_Csp,Npim)            ! Particulate inorganic C-concentration
#if defined CARBON_ISOTOPE
  integer :: iT13C                  ! Corbon 13 of total inorganic carbon
  integer :: iDO13C(Ndom)          ! Dissolved organic 13C-concentration
  integer :: iPO13C(Npom)          ! Particulate organic 13C-concentration
  integer :: iPhyt13C(Nphy)       ! Phytoplankton1 13C-concentration
  integer :: iZoop13C(Nzoo)       ! Zooplankton 13C-concentration
  integer :: iPI13C(Npim)          ! Particulate inorganic 13C-concentration
#endif
#if defined NITROGEN_ISOTOPE
  integer :: i15NO3                  ! Nitrogen isotope concentration in Nitrate 
!  integer :: i15NO2                  ! Nitrogen isotope concentration in Nitrite
  integer :: i15NH4                  ! Nitrogen isotope concentration in Ammonium
  integer :: iDO15N(Ndom)          ! Dissolved organic 15N-concentration
  integer :: iPO15N(Npom)          ! Particulate organic 15N-concentration
  integer :: iPhyt15N(Nphy)       ! Phytoplankton 15N-concentration
  integer :: iZoop15N(Nzoo)       ! Zooplankton 15N-concentration
#endif
#if defined COT_STARFISH
  integer :: iCOTe                  ! Eggs of crown-of-thorns starfish
  integer :: iCOTl                  ! Larvae of crown-of-thorns starfish
#endif

  real(8), allocatable :: dz(:,:,:)    
  real(8), allocatable :: t(:,:,:,:,:)
  real(8), allocatable :: dtrc_dt(:,:)
  real(8), allocatable :: pH(:,:,:)
  real(8), allocatable :: Warg(:,:,:)
  real(8), allocatable :: Wcal(:,:,:)
#if defined LIGHT_MODEL
  real(8), allocatable :: PFDk(:,:,:)  
#endif
  
  real(8), allocatable :: p_coral(:,:,:)
  real(8), allocatable :: p_sgrass(:,:,:)
  real(8), allocatable :: p_algae(:,:,:)
  real(8), allocatable :: p_sand(:,:)

#if defined SEDECO_SGD && defined SGD_ON
  real(8) :: sgd_flux        ! sumbarine groundwater discharge rate of grid (cm s-1)  
  real(8) :: sgd_Tmp         ! SGD concentration coming in through bottom: Tmp: Temperature (oC)
  real(8) :: sgd_Sal         ! SGD concentration coming in through bottom: Sal: Salinity (PSU)
  real(8) :: sgd_DIC(N_Csp)  ! SGD concentration coming in through bottom: DIC: Total dissolved inorganic carbon (DIC: umol kg-1)
  real(8) :: sgd_TA          ! SGD concentration coming in through bottom: TA : Total alkalinity (TA: umol kg-1)
  real(8) :: sgd_DOx         ! SGD concentration coming in through bottom: DOx: Dissolved oxygen (umol L-1)
  real(8) :: sgd_NO3(N_Nsp)  ! SGD concentration coming in through bottom: NO3: NO3 (umol L-1)
  real(8) :: sgd_NH4(N_Nsp)  ! SGD concentration coming in through bottom: NH4: NH4 (umol L-1)
  real(8) :: sgd_PO4(N_Psp)  ! SGD concentration coming in through bottom: PO4: PO4 (umol L-1)
  real(8) :: sgd_DOC(N_Csp,Ndom)  ! SGD concentration coming in through bottom: DOC: Total dissolved organic carbon (DOC: umol L-1)
  real(8) :: sgd_DON(N_Nsp,Ndom)  ! SGD concentration coming in through bottom: DOC: Total dissolved organic nitrogen (DON: umol L-1)
  real(8) :: sgd_DOP(N_Psp,Ndom)  ! SGD concentration coming in through bottom: DOC: Total dissolved organic phosphrous (DOP: umol L-1)
#endif
#if defined SEDECO_BURIAL
  real(8) :: Fdep_sed        ! Sedimentation rate (cm s-1) (Positive: sedimentation; Negative: erosion)
#endif

contains

!!! **********************************************************************
!!!  Set initial conditions
!!! **********************************************************************

  subroutine initialize_params(LBi, UBi, LBj, UBj, N, Nid)

    USE mod_reef_ecosys_param
    use mod_geochem
   
    implicit none
! input parameters
    integer, intent(in) :: LBi, UBi, LBj, UBj, N
    integer, intent(out) :: Nid
    real(8)  R13C
    integer i,j,k,nstp,m,isp
!  Local variable declarations JS_edit
!
    integer :: ic

    real(8) :: T0, S0, Sed1_0
    real(8) :: TAlk0, TIC_0, Oxyg0
    real(8) :: NO3_0, NH4_0, PO4_0
    real(8) :: DOC_0(Ndom), POC_0(Npom), PhyC_0(Nphy), ZooC_0(Nzoo), PIC_0(Npim)
!    real(8) :: DON_0(Ndom), PON_0(Npom), PhyN_0(Nphy), ZooN_0(Nzoo)
!    real(8) :: DOP_0(Ndom), POP_0(Npom), PhyP_0(Nphy), ZooP_0(Nzoo)
    real(8) :: d13C_TIC0, d13C_DOC_0(Ndom), d13C_POC_0(Npom)
    real(8) :: d13C_PhyC_0(Nphy), d13C_ZooC_0(Nzoo), d13C_PIC_0(Npim)
    real(8) :: d15N_NO3_0, d15N_NH4_0, d15N_DON_0(Ndom), d15N_PON_0(Npom)
    real(8) :: d15N_PhyN_0(Nphy), d15N_ZooN_0(Nzoo)
    real(8) :: p_coral_0(Ncl), p_algae_0(Nag), p_sgrass_0(Nsg), p_sand_0

    namelist/initial/T0, S0, Sed1_0
    namelist/initial/TAlk0, TIC_0, Oxyg0
    namelist/initial/NO3_0, NH4_0, PO4_0
    namelist/initial/DOC_0, POC_0, PhyC_0, ZooC_0, PIC_0
!    namelist/initial/DON_0, PON_0, PhyN_0, ZooN_0
!    namelist/initial/DOP_0, POP_0, PhyP_0, ZooP_0
    namelist/initial/d13C_TIC0, d13C_DOC_0, d13C_POC_0
    namelist/initial/d13C_PhyC_0, d13C_ZooC_0, d13C_PIC_0
    namelist/initial/d15N_NO3_0, d15N_NH4_0, d15N_DON_0, d15N_PON_0
    namelist/initial/d15N_PhyN_0, d15N_ZooN_0
    namelist/initial/p_coral_0, p_algae_0, p_sgrass_0, p_sand_0
 
    read (5, nml=initial)
    rewind(5)
!
!-----------------------------------------------------------------------
!  Initialize tracer identification indices.
!-----------------------------------------------------------------------
!
    ic=0

    i=1
    iTemp=ic+i
    i=i+1
    iSalt=ic+i

    i=i+1
    iSedi=ic+i

! REEF_ECOSYS parameter IDs
    i=i+1
    iOxyg=ic+i
    i=i+1
    iTAlk=ic+i
    DO isp=1,N_Csp     
      i=i+1
      iTIC(isp)=ic+i
    END DO       
    DO isp=1,N_Nsp
      i=i+1     
      iNO3(isp)=ic+i
    END DO       
    DO isp=1,N_Nsp
      i=i+1    
      iNH4(isp)=ic+i       
    END DO       
    DO isp=1,N_Psp     
      i=i+1    
      iPO4(isp)=ic+i       
    END DO
    DO m=1,Ndom    
      DO isp=1,N_Csp     
        i=i+1    
        iDOC(isp,m)=ic+i
      END DO
    END DO 
    DO m=1,Ndom    
      DO isp=1,N_Nsp     
        i=i+1    
        iDON(isp,m)=ic+i 
      END DO
    END DO 
    DO m=1,Ndom    
      DO isp=1,N_Psp     
        i=i+1    
        iDOP(isp,m)=ic+i  
      END DO
    END DO 
    DO m=1,Npom    
      DO isp=1,N_Csp     
        i=i+1    
        iPOC(isp,m)=ic+i  
      END DO
    END DO 
    DO m=1,Npom    
      DO isp=1,N_Nsp     
        i=i+1    
        iPON(isp,m)=ic+i  
      END DO
    END DO 
    DO m=1,Npom    
      DO isp=1,N_Psp     
        i=i+1    
        iPOP(isp,m)=ic+i  
      END DO
    END DO 
    DO m=1,Nphy    
      DO isp=1,N_Csp     
        i=i+1    
        iPhyC(isp,m)=ic+i
      END DO
    END DO 
    DO m=1,Nphy    
      DO isp=1,N_Nsp     
        i=i+1    
        iPhyN(isp,m)=ic+i
      END DO
    END DO 
    DO m=1,Nphy    
      DO isp=1,N_Psp     
        i=i+1    
        iPhyP(isp,m)=ic+i
      END DO
    END DO 
    DO m=1,Nzoo    
      DO isp=1,N_Csp     
        i=i+1    
        iZooC(isp,m)=ic+i
      END DO
    END DO 
    DO m=1,Nzoo    
      DO isp=1,N_Nsp     
        i=i+1    
        iZooN(isp,m)=ic+i
      END DO
    END DO 
    DO m=1,Nzoo    
      DO isp=1,N_Psp     
        i=i+1    
        iZooP(isp,m)=ic+i
      END DO
    END DO 
    DO m=1,Npim    
      DO isp=1,N_Csp     
        i=i+1    
        iPIC(isp,m)=ic+i 
      END DO
    END DO 
#if defined COT_STARFISH
    i=i+1
    iCOTe=ic+i
    i=i+1
    iCOTl=ic+i
#endif


!-----------------------------------------------------------------------
!  Determine number of biological tracers.
!-----------------------------------------------------------------------

    Nid=i
!---------------------------------------------------------------------


   allocate( dz(LBi:UBi,LBj:UBj,N) )

   allocate( t(LBi:UBi, LBj:UBj, N, 1, Nid) , &
             dtrc_dt(N, Nid)   )
   allocate( pH(LBi:UBi, LBj:UBj, N) )
   allocate( Warg(LBi:UBi, LBj:UBj, N) )
   allocate( Wcal(LBi:UBi, LBj:UBj, N) )
#if defined LIGHT_MODEL
   allocate( PFDk(LBi:UBi, LBj:UBj, N) )
#endif
   
   allocate( p_coral (2,LBi:UBi, LBj:UBj) , &  !!! To be updated... !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
             p_sgrass(1,LBi:UBi, LBj:UBj) , &  !!! To be updated... !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
             p_sand  (LBi:UBi, LBj:UBj) ,   &
             p_algae (1,LBi:UBi, LBj:UBj)   )  !!! To be updated... !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 


!-----------------------------------------------------------------------
!  Set initial conditions
!-----------------------------------------------------------------------
    nstp=1
    t(:,:,:,:,:) = 0.0d0 ! Initialize all tracers to zero

    do j=LBj,UBj
      do i=LBi,UBi
        do k=1,N
        
          t(i,j,k,nstp,iTemp) = T0       
          t(i,j,k,nstp,iSalt) = S0

          t(i,j,k,nstp,iSedi) = Sed1_0    !Sediment concentration (g m-3) 0.e0, 1.e0

!          t(i,j,k,nstp,iOxyg) = Oxyg0      !DO  (umol L-1)
          t(i,j,k,nstp,iOxyg) = O2satu(t(i,j,k,nstp,iTemp)+273.15d0, t(i,j,k,nstp,iSalt))
          t(i,j,k,nstp,iTAlk) = TAlk0      !TA  (umol kg-1)  2232.0d0 2275.0d0, 2500.0d0, 2150.0d0, 2000.0d0, 1800.0d0, 1700.0d0, 1600.0d0 
          t(i,j,k,nstp,iTIC(iCt)) = TIC_0     !DIC  (umol kg-1) 1915.0d0 1930.0d0, 1700.0d0, 2100.0d0, 2300.0d0, 2500.0d0, 2700.0d0, 3000.0d0 
          t(i,j,k,nstp,iNO3(iNt)) = NO3_0      !NO3  (umol L-1)  0.5d0, 10.0d0 control0.2d0 N1.8d0 N*2 3.5d0
          t(i,j,k,nstp,iNH4(iNt)) = NH4_0      !NH4  (umol L-1) 
          t(i,j,k,nstp,iPO4(iPt)) = PO4_0      !PO4  (umol L-1) 0.03d0 0.05d0, 2.0d0 control0.04d0 P0.2d0
          DO m=1,Ndom
            t(i,j,k,nstp,iDOC(iCt,m)) = DOC_0(m)       !DOC  (umol L-1) 
!            t(i,j,k,nstp,iDON(iNt,m)) = DON_0(m)     !DON  (umol L-1) 
!            t(i,j,k,nstp,iDOP(iPt,m)) = DOP_0(m)     !DOP  (umol L-1) 
            t(i,j,k,nstp,iDON(iNt,m)) = DOC_0(m)*16d0/106d0     !DON  (umol L-1) 
            t(i,j,k,nstp,iDOP(iPt,m)) = DOC_0(m)/106d0     !DOP  (umol L-1) 
          END DO
          DO m=1,Npom
            t(i,j,k,nstp,iPOC(iCt,m)) = POC_0(m)       !POC  (umol L-1) 
!            t(i,j,k,nstp,iPON(iNt,m)) = PON_0(m)     !PON  (umol L-1) 
!            t(i,j,k,nstp,iPOP(iPt,m)) = POP_0(m)      !POP  (umol L-1) 
            t(i,j,k,nstp,iPON(iNt,m)) = POC_0(m)*16d0/106d0     !PON  (umol L-1) 
            t(i,j,k,nstp,iPOP(iPt,m)) = POC_0(m)/106d0      !POP  (umol L-1) 
          END DO

#if defined CPOM_TRACERS
          ! ***CPOM TRACER TEST****
          t(i,j,k,nstp,iPOC(iC13,iCPOM)) = POC_0(iCPOM)       !POC  (umol L-1) 
          t(i,j,k,nstp,iPON(iN15,iCPOM)) = POC_0(iCPOM)*16d0/106d0     !PON  (umol L-1) 
          t(i,j,k,nstp,iPOP(iP1, iCPOM)) = POC_0(iCPOM)/106d0      !POP  (umol L-1)
#endif
          DO m=1,Nphy
            t(i,j,k,nstp,iPhyC(iCt,m)) = PhyC_0(m)     !Phytoplankton1 0.3(umolC L-1) all0.561 0.746-gC/gchla-1h 2.23-gC/gchla-30 4.47-gC/gchla-60	others
!            t(i,j,k,nstp,iPhyN(iNt,m)) = PhyN_0(m)     !Phytoplankton1 0.3(umolC L-1) all0.561 0.746-gC/gchla-1h 2.23-gC/gchla-30 4.47-gC/gchla-60	others
!            t(i,j,k,nstp,iPhyP(iPt,m)) = PhyP_0(m)     !Phytoplankton1 0.3(umolC L-1) all0.561 0.746-gC/gchla-1h 2.23-gC/gchla-30 4.47-gC/gchla-60	others
            t(i,j,k,nstp,iPhyN(iNt,m)) = PhyC_0(m)*rNCp(m)     !Phytoplankton1 0.3(umolC L-1) all0.561 0.746-gC/gchla-1h 2.23-gC/gchla-30 4.47-gC/gchla-60	others
            t(i,j,k,nstp,iPhyP(iPt,m)) = PhyC_0(m)*rPCp(m)     !Phytoplankton1 0.3(umolC L-1) all0.561 0.746-gC/gchla-1h 2.23-gC/gchla-30 4.47-gC/gchla-60	others
          END DO
          DO m=1,Nzoo
            t(i,j,k,nstp,iZooC(iCt,m)) = ZooC_0(m)     !Zooplankton (umol L-1)1.3
!            t(i,j,k,nstp,iZooN(iNt,m)) = ZooN_0(m)     !Zooplankton (umol L-1)1.3
!            t(i,j,k,nstp,iZooP(iPt,m)) = ZooP_0(m)     !Zooplankton (umol L-1)1.3
            t(i,j,k,nstp,iZooN(iNt,m)) = ZooC_0(m)*rNCz(m)     !Zooplankton (umol L-1)1.3
            t(i,j,k,nstp,iZooP(iPt,m)) = ZooC_0(m)*rPCz(m)     !Zooplankton (umol L-1)1.3
          END DO
          DO m=1,Npim
            t(i,j,k,nstp,iPIC (iCt,m)) = PIC_0 (m)     !Particulated inorganic carbon (umol L-1)1.3
          END DO
          t(i,j,k,nstp,iPIC (iCt,iLive)) = PhyC_0(iCcl)*rCaCp(iCcl)     !Particulated inorganic carbon (umol L-1)

#if defined CARBON_ISOTOPE
          R13C=R13C_fromd13C(d13C_TIC0)
          t(i,j,k,nstp,iT13C) =R13C*t(i,j,k,nstp,iTIC_) !DI13C (umol kg-1) 
          R13C=R13C_fromd13C(d13C_DOC1_0)
          t(i,j,k,nstp,iDO13C(1)) = R13C*t(i,j,k,nstp,iDO13C(1))       !DOC  (umol L-1) 
          R13C=R13C_fromd13C(d13C_DOC2_0)
          t(i,j,k,nstp,iDO13C(2)) = R13C*t(i,j,k,nstp,iDO13C(2))      !DOC  (umol L-1) 
          R13C=R13C_fromd13C(d13C_POC1_0)
          t(i,j,k,nstp,iPO13C(1)) = R13C*t(i,j,k,nstp,iPO13C(1))        !POC  (umol L-1) 
          R13C=R13C_fromd13C(d13C_POC2_0)
          t(i,j,k,nstp,iPO13C(2)) = R13C*t(i,j,k,nstp,iPO13C(2))        !POC  (umol L-1) 
          R13C=R13C_fromd13C(d13C_Phyt1_0)
          t(i,j,k,nstp,iPhyt13C(1)) = R13C*t(i,j,k,nstp,iPhyt13C(1))     !Phytoplankton1 0.3(umolC L-1) all0.561 0.746-gC/gchla-1h 2.23-gC/gchla-30 4.47-gC/gchla-60	others
          R13C=R13C_fromd13C(d13C_Phyt2_0)
          t(i,j,k,nstp,iPhyt13C(2)) = R13C*t(i,j,k,nstp,iPhyt13C(2))       !Phytoplankton2 0.3(umolC L-1) 							diatom
          R13C=R13C_fromd13C(d13C_Phyt3_0)
          t(i,j,k,nstp,iPhyt13C(3)) = R13C*t(i,j,k,nstp,iPhyt13C(3))       !Phytoplankton3 0.3(umolC L-1) 							diatom
          R13C=R13C_fromd13C(d13C_Zoop1_0)
          t(i,j,k,nstp,iZoop13C(1)) = R13C*t(i,j,k,nstp,iZoop13C(1))       !Zooplankton (umol L-1)1.3
          R13C=R13C_fromd13C(d13C_PIC1_0)
          t(i,j,k,nstp,iPI13C(1)) = R13C*t(i,j,k,nstp,iPI13C(1))       !Particulated inorganic carbon (umol L-1)1.3
#endif
!!!!!!!!!!!!
#if defined NITROGEN_ISOTOPE            
!!!!!!!!!!!!
          t(i,j,k,nstp,i15NO3) =  0.2d0       !NO3  (umol L-1)  0.5d0, 10.0d0 control0.2d0 N1.8d0 N*2 3.5d0
          t(i,j,k,nstp,i15NH4) =  0.26d0       !NH4  (umol L-1) 

          t(i,j,k,nstp,iDO15N(1)) =   1.0d0 !3.0d0       !DON  (umol L-1) 
          t(i,j,k,nstp,iDO15N(2)) =  10.0d0 !3.0d0       !DON  (umol L-1) 
          t(i,j,k,nstp,iPO15N(1)) =  0.06d0 !0.05d0      !PON  (umol L-1) 
          t(i,j,k,nstp,iPO15N(2)) =  0.6d0 !0.05d0      !PON  (umol L-1) 
          t(i,j,k,nstp,iPhyt15N(1)) = 0.0d0     !Phytoplankton1 0.3(umolC L-1) all0.561 0.746-gC/gchla-1h 2.23-gC/gchla-30 4.47-gC/gchla-60	others
          t(i,j,k,nstp,iPhyt15N(2)) = 0.0d0       !Phytoplankton2 0.3(umolC L-1) 							diatom
          t(i,j,k,nstp,iPhyt15N(3)) = 0.0d0       !Phytoplankton2 0.3(umolC L-1) 							diatom
          t(i,j,k,nstp,iZoop15N(1)) = 0.0d0       !Zooplankton (umol L-1)1.3
#endif
#if defined COT_STARFISH
          t(i,j,k,nstp,iCOTe) =  0.0d0       !COTS eggs (umol L-1) 
          t(i,j,k,nstp,iCOTl) =  0.0d0       !COTS larvae (umol L-1) 
#endif
        enddo
          
#if defined CHAMBER_SITE4
        p_coral(1,i,j) = 0.208d0  ! Site4: 0.208d0, Site5: 0.265d0, Site6: 0.37d0, Site7: 0.231d0
        p_coral(2,i,j) = 0.0d0    ! Site9: 0.412d0, Site10: 0.486d0
        p_sand(i,j)  = 1.0d0-p_coral(1,i,j)
#elif defined CHAMBER_SITE5
        p_coral(1,i,j) = 0.265d0  ! Site4: 0.208d0, Site5: 0.265d0, Site6: 0.37d0, Site7: 0.231d0
        p_coral(2,i,j) = 0.0d0    ! Site9: 0.412d0, Site10: 0.486d0
        p_sand(i,j)  = 1.0d0-p_coral(1,i,j)
#elif defined CHAMBER_SITE6
        p_coral(1,i,j) = 0.37d0  ! Site4: 0.208d0, Site5: 0.265d0, Site6: 0.37d0, Site7: 0.231d0
        p_coral(2,i,j) = 0.0d0    ! Site9: 0.412d0, Site10: 0.486d0
        p_sand(i,j)  = 1.0d0-p_coral(1,i,j)
#elif defined CHAMBER_SITE7
        p_coral(1,i,j) = 0.231d0  ! Site4: 0.208d0, Site5: 0.265d0, Site6: 0.37d0, Site7: 0.231d0
        p_coral(2,i,j) = 0.0d0    ! Site9: 0.412d0, Site10: 0.486d0
        p_sand(i,j)  = 1.0d0-p_coral(1,i,j)
#elif defined CHAMBER_SITE9
        p_coral(1,i,j) = 0.0d0  ! Site4: 0.208d0, Site5: 0.265d0, Site6: 0.37d0, Site7: 0.231d0
        p_coral(2,i,j) = 0.412d0    ! Site9: 0.412d0, Site10: 0.486d0
        p_sand(i,j)  = 0.0d0
#elif defined CHAMBER_SITE10
        p_coral(1,i,j) = 0.0d0  ! Site4: 0.208d0, Site5: 0.265d0, Site6: 0.37d0, Site7: 0.231d0
        p_coral(2,i,j) = 0.486d0    ! Site9: 0.412d0, Site10: 0.486d0
        p_sand(i,j)  = 0.0d0

#else
        p_coral(1,i,j) = p_coral_0(1)
        p_coral(2,i,j) = p_coral_0(2)
        p_sand(i,j)  = p_sand_0
#endif
        p_algae(1,i,j) = p_algae_0(1)
        p_sgrass(1,i,j)= p_sgrass_0(1)
        
        
      enddo
    enddo
    
    ereef = 0.0d0

    return
  end subroutine initialize_params

END MODULE mod_param

