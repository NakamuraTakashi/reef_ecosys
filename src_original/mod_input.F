
!!!=== Copyright (c) 2012-2025 Takashi NAKAMURA  =====

!--------------------------------------------------------------------------------
!
!              Input module
!
!--------------------------------------------------------------------------------

#include "cppdefs.h"

module mod_input

contains
! **********************************************************************
!  Read timeseries data file
! **********************************************************************
  subroutine read_data(in_file)
    USE mod_param
    
    implicit none
    
    integer, intent(IN ) :: in_file(12)

    character(256), allocatable :: SWRad_FILE(:)
    character(256), allocatable :: LWRad_FILE(:)
    character(256), allocatable :: Tair_FILE(:)
    character(256), allocatable :: Pair_FILE(:)
    character(256), allocatable :: Wind_FILE(:)
    character(256), allocatable :: Rain_FILE(:)
    character(256), allocatable :: Rh_FILE(:)  
    character(256), allocatable :: Cloud_FILE(:)  
    character(256), allocatable :: PPFD_FILE(:)
    character(256), allocatable :: WTEMP_FILE(:)
    character(256), allocatable :: WLEVEL_FILE(:)
    character(256), allocatable :: WAVE_FILE(:)
    integer :: Ryear, Rmonth, Rday

    integer, allocatable :: num_data(:)
    integer :: ios
    integer :: i,j
    real(8) :: tmp
    integer :: Num_header = 0

    namelist/refdate/Ryear, Rmonth, Rday
    namelist/input/SWRad_FILE, LWRad_FILE, Tair_FILE, Pair_FILE  &
                 , Wind_FILE, Rain_FILE, Rh_FILE, Cloud_FILE                 &
                 , PPFD_FILE, WTEMP_FILE, WLEVEL_FILE, WAVE_FILE
  
    read (5, nml=refdate)
    rewind(5)

    if ( in_file(iswrad) == 0 ) then
      allocate( SWRad_FILE(1) )
    else
      allocate( SWRad_FILE(in_file(iswrad)) )
    endif
    if ( in_file(idlwrad) == 0 ) then
      allocate( LWRad_FILE(1) )
    else
      allocate( LWRad_FILE(in_file(idlwrad)) )
    endif
    if ( in_file(iTair) == 0 ) then
      allocate( Tair_FILE(1) )
    else
      allocate( Tair_FILE(in_file(iTair)) )
    endif
    if ( in_file(iPair) == 0 ) then
      allocate( Pair_FILE(1) )
    else
      allocate( Pair_FILE(in_file(iPair)) )
    endif
    if ( in_file(iwind) == 0 ) then
      allocate( Wind_FILE(1) )
    else
      allocate( Wind_FILE(in_file(iwind)) )
    endif
    if ( in_file(irain) == 0 ) then
      allocate( Rain_FILE(1) )
    else
      allocate( Rain_FILE(in_file(irain)) )
    endif
    if ( in_file(iRh) == 0 ) then
      allocate( Rh_FILE(1) )
    else
      allocate( Rh_FILE(in_file(iRh)) )
    endif
    if ( in_file(icloud) == 0 ) then
      allocate( Cloud_FILE(1) )
    else
      allocate( Cloud_FILE(in_file(icloud)) )
    endif
    if ( in_file(iPFD) == 0 ) then
      allocate( PPFD_FILE(1) )
    else
      allocate( PPFD_FILE(in_file(iPFD)) )
    endif
    if ( in_file(iwtemp) == 0 ) then
      allocate( WTEMP_FILE(1) )
    else
      allocate( WTEMP_FILE(in_file(iwtemp)) )
    endif
    if ( in_file(itide) == 0 ) then
      allocate( WLEVEL_FILE(1) )
    else
      allocate( WLEVEL_FILE(in_file(itide)) )
    endif
    if ( in_file(iwv) == 0 ) then
      allocate( WAVE_FILE(1) )
    else
      allocate( WAVE_FILE(in_file(iwv)) )
    endif

    read (5, nml=input)
    rewind(5)

! ==== READ swrad data =============================================
    if ( in_file(iswrad) > 0 ) then
      Num_header = 0
#ifdef INPUT_ROMS_FRC
      CALL read_infiles_nc(in_file(iswrad), SWRad_FILE, "swrad"          &
             , num_swrad, swrad_time, swrad_data)
#else
      CALL read_infiles_ascii(in_file(iswrad), SWRad_FILE, Num_header    &
             , num_swrad, swrad_time, swrad_data)
#endif
    endif

! ==== READ dlwrad data =============================================
    if ( in_file(idlwrad) > 0 ) then
      Num_header = 0
#ifdef INPUT_ROMS_FRC
      CALL read_infiles_nc(in_file(idlwrad), LWRad_FILE, "lwrad_down"          &
             , num_dlwrad, dlwrad_time, dlwrad_data)
#else
      CALL read_infiles_ascii(in_file(idlwrad), LWRad_FILE, Num_header    &
             , num_dlwrad, dlwrad_time, dlwrad_data)
#endif
!      do i=1, num_dlwrad
!        write(94,*) dlwrad_time(i), dlwrad_data(i)
!      end do
    endif

! ==== READ Tair data =============================================
    if ( in_file(iTair) > 0 ) then
      Num_header = 0
#ifdef INPUT_ROMS_FRC
      CALL read_infiles_nc(in_file(iTair), Tair_FILE, "Tair"          &
             , num_Tair, Tair_time, Tair_data)
#else
      CALL read_infiles_ascii(in_file(iTair), Tair_FILE, Num_header    &
             , num_Tair, Tair_time, Tair_data)
#endif
    endif
! ==== READ Pair data =============================================
    if ( in_file(iPair) > 0 ) then
      Num_header = 0
#ifdef INPUT_ROMS_FRC
      CALL read_infiles_nc(in_file(iPair), Pair_FILE, "Pair"          &
             , num_Pair, Pair_time, Pair_data)
#else
      CALL read_infiles_ascii(in_file(iPair), Pair_FILE, Num_header    &
             , num_Pair, Pair_time, Pair_data)
#endif
    endif
! ==== READ wind data =============================================
    if ( in_file(iwind) > 0 ) then
      Num_header = 0
#ifdef INPUT_ROMS_FRC
      CALL read_infiles_nc2(in_file(iwind), Wind_FILE, "Uwind", "Vwind"    &
             , num_wind, wind_time, Uwind_data, Vwind_data)
#else
      CALL read_infiles_ascii2(in_file(iwind), Wind_FILE, Num_header    &
             , num_wind, wind_time, Uwind_data, Vwind_data)
#endif
!      do i=1, num_wind
!        write(94,*) wind_time(i), Uwind_data(i), Vwind_data(i)
!      end do
    endif
! ==== READ rain data =============================================
    if ( in_file(irain) > 0 ) then
      Num_header = 0
#ifdef INPUT_ROMS_FRC
      CALL read_infiles_nc(in_file(irain), Rain_FILE, "rain"          &
             , num_rain, rain_time, rain_data)
#else
      CALL read_infiles_ascii(in_file(irain), Rain_FILE, Num_header    &
             , num_rain, rain_time, rain_data)
#endif
    endif
! ==== READ Rh data =============================================
    if ( in_file(iRh) > 0 ) then
      Num_header = 0
#ifdef INPUT_ROMS_FRC
      CALL read_infiles_nc(in_file(iRh), Rh_FILE, "Qair"          &
             , num_Rh, Rh_time, Rh_data)
#else
      CALL read_infiles_ascii(in_file(iRh), Rh_FILE, Num_header    &
             , num_Rh, Rh_time, Rh_data)
#endif
    endif
! ==== READ cloud data =============================================
    if ( in_file(icloud) > 0 ) then
      Num_header = 0
#ifdef INPUT_ROMS_FRC
      CALL read_infiles_nc(in_file(icloud), Cloud_FILE, "cloud"          &
             , num_cloud, cloud_time, cloud_data)
#else
      CALL read_infiles_ascii(in_file(icloud), Cloud_FILE, Num_header    &
             , num_cloud, cloud_time, cloud_data)
#endif
    endif

! ==== READ PPFD data =============================================
    if ( in_file(iPFD) > 0 ) then
      Num_header = 0
      CALL read_infiles_ascii(in_file(iPFD), PPFD_FILE, Num_header    &
             , num_PFD, PFD_time, PFD_data)
    endif    

! ==== READ water temp data =============================================
    if ( in_file(iwtemp) > 0 ) then
#ifdef INPUT_ROMS_NCDUMP
      Num_header = 4
#else
      Num_header = 0
#endif
      CALL read_infiles_ascii(in_file(iwtemp), WTEMP_FILE, Num_header    &
             , num_wtemp, wtemp_time, wtemp_data)
#ifdef INPUT_ROMS_NCDUMP
      wtemp_time(:) = wtemp_time(:)/86400.0d0  ! sec -> day
#endif
    endif
      
! ==== READ tide data =============================================
    if ( in_file(itide) > 0 ) then
#ifdef INPUT_ROMS_NCDUMP
      Num_header = 4
#else
      Num_header = 0
#endif
      CALL read_infiles_ascii(in_file(itide), WLEVEL_FILE, Num_header    &
             , num_tide, tide_time, tide_data)
#ifdef INPUT_ROMS_NCDUMP
      tide_time(:) = tide_time(:)/86400.0d0  ! sec -> day
#endif
    endif
! ==== READ wave data =============================================
    if ( in_file(iwv) > 0 ) then
#ifdef INPUT_SWAN
      Num_header = 1
#else
      Num_header = 0
#endif
      CALL read_infiles_wave(in_file(iwv), WAVE_FILE, Num_header    &
             , Ryear, Rmonth, Rday                                &
             , num_wv, wv_time, Hs_data, Tp_data)
    endif
  end subroutine read_data

! **********************************************************************

  subroutine read_infiles_ascii(Num_file, FILE_NAME, Num_header    &
             , Num_data, time, data)

    integer, intent(IN ) :: Num_file
    character(256), intent(IN ) :: FILE_NAME(Num_file)
    integer, intent(IN ) :: Num_header
    integer, intent(OUT) :: Num_data
    real(8), intent(OUT), allocatable :: time(:)
    real(8), intent(OUT), allocatable :: data(:)

    integer, allocatable :: num_d(:)

    allocate( num_d(0:Num_file) )
    Num_data = 0
    num_d(0) = 0
  
    do j=1, Num_file
! ----- Open data ---------------------------------------------
      open(77,file=FILE_NAME(j))     
!  ---- count data number -----
      num_d(j) = 0
      do
        read(77,*,iostat=ios) 
        if(ios==-1) exit
        num_d(j) = num_d(j)+1
      end do
      close(77)
      num_d(j) = num_d(j) - Num_header 
      Num_data = Num_data + num_d(j)
    end do
  
    allocate( time(Num_data) )
    allocate( data(Num_data) )

    do j=1, Num_file
! ----- Open data ---------------------------------------------
      open(77,file=FILE_NAME(j))     
        
!  ---- Read data -----
      do i=1, Num_header
        read(77,*)
      end do

      do i=num_d(j-1)+1, num_d(j)+num_d(j-1)
        read(77,*) time(i), data(i)
!        write(97,*) time(i), data(i)
      end do
      close(77)
    end do
    deallocate( num_d )

  end subroutine read_infiles_ascii

! **********************************************************************

  subroutine read_infiles_ascii2(Num_file, FILE_NAME, Num_header    &
             , Num_data, time, data1, data2)

    integer, intent(IN ) :: Num_file
    character(256), intent(IN ) :: FILE_NAME(Num_file)
    integer, intent(IN ) :: Num_header
    integer, intent(OUT) :: Num_data
    real(8), intent(OUT), allocatable :: time(:)
    real(8), intent(OUT), allocatable :: data1(:)
    real(8), intent(OUT), allocatable :: data2(:)

    integer, allocatable :: num_d(:)

    allocate( num_d(0:Num_file) )
    Num_data = 0
    num_d(0) = 0
  
    do j=1, Num_file
! ----- Open data ---------------------------------------------
      open(77,file=FILE_NAME(j))     
!  ---- count data number -----
      num_d(j) = 0
      do
        read(77,*,iostat=ios) 
        if(ios==-1) exit
        num_d(j) = num_d(j)+1
      end do
      close(77)
      num_d(j) = num_d(j) - Num_header 
      Num_data = Num_data + num_d(j)
    end do
  
    allocate( time(Num_data) )
    allocate( data1(Num_data) )
    allocate( data2(Num_data) )

    do j=1, Num_file
! ----- Open data ---------------------------------------------
      open(77,file=FILE_NAME(j))     
        
!  ---- Read data -----
      do i=1, Num_header
        read(77,*)
      end do

      do i=num_d(j-1)+1, num_d(j)+num_d(j-1)
        read(77,*) time(i), data1(i), data2(i)
      end do
      close(77)
    end do
    deallocate( num_d )

  end subroutine read_infiles_ascii2
! **********************************************************************

  subroutine read_infiles_nc(Num_file, FILE_NAME, NCNAME    &
             , Num_data, time, data)
    use netcdf

    integer, intent(IN ) :: Num_file
    character(256), intent(IN ) :: FILE_NAME(Num_file)
    character(len=*), intent(IN ) :: NCNAME
    integer, intent(OUT) :: Num_data
    real(8), intent(OUT), allocatable :: time(:)
    real(8), intent(OUT), allocatable :: data(:)

    integer, allocatable :: num_d(:)
    integer :: status
    integer, allocatable :: ncid(:)
    integer :: var_id, dimid
    integer :: is,ie

    allocate( num_d(0:Num_file) )
    allocate( ncid(Num_file) )

    Num_data = 0
    num_d(0) = 0
  
    do j=1, Num_file
! ----- Open nc file ---------------------------------------------
      status = nf90_open(FILE_NAME(j), nf90_nowrite, ncid(j))
!  ---- count data number -----
      status = nf90_inq_dimid(ncid(j), 'time', dimid)
      status = nf90_inquire_dimension(ncid(j), dimid, len=num_d(j))

      Num_data = Num_data + num_d(j)
    end do
  
    allocate( time(Num_data) )
    allocate( data(Num_data) )

    do j=1, Num_file
! ----- Open data ---------------------------------------------
      is = num_d(j-1)+1
      ie = num_d(j)+num_d(j-1)
      status = nf90_inq_varid(ncid(j), 'time', var_id)
      status = nf90_get_var(ncid(j), var_id, time(is:ie)) 
      status = nf90_inq_varid(ncid(j), NCNAME, var_id)
      status = nf90_get_var(ncid(j), var_id, data(is:ie))
      status = nf90_close(ncid(j))
    end do
    deallocate( num_d )
    deallocate( ncid )

  end subroutine read_infiles_nc
! **********************************************************************

  subroutine read_infiles_nc2(Num_file, FILE_NAME, NCNAME1, NCNAME2    &
             , Num_data, time, data1, data2)
    use netcdf

    integer, intent(IN ) :: Num_file
    character(256), intent(IN ) :: FILE_NAME(Num_file)
    character(len=*), intent(IN ) :: NCNAME1
    character(len=*), intent(IN ) :: NCNAME2
    integer, intent(OUT) :: Num_data
    real(8), intent(OUT), allocatable :: time(:)
    real(8), intent(OUT), allocatable :: data1(:)
    real(8), intent(OUT), allocatable :: data2(:)

    integer, allocatable :: num_d(:)
    integer :: status
    integer, allocatable :: ncid(:)
    integer :: var_id, dimid
    integer :: is,ie

    allocate( num_d(0:Num_file) )
    allocate( ncid(Num_file) )

    Num_data = 0
    num_d(0) = 0
  
    do j=1, Num_file
! ----- Open nc file ---------------------------------------------
      status = nf90_open(FILE_NAME(j), nf90_nowrite, ncid(j))
!  ---- count data number -----
      status = nf90_inq_dimid(ncid(j), 'time', dimid)
      status = nf90_inquire_dimension(ncid(j), dimid, len=num_d(j))

      Num_data = Num_data + num_d(j)
    end do
  
    allocate( time(Num_data) )
    allocate( data1(Num_data) )
    allocate( data2(Num_data) )

    do j=1, Num_file
! ----- Open data ---------------------------------------------
      is = num_d(j-1)+1
      ie = num_d(j)+num_d(j-1)
      status = nf90_inq_varid(ncid(j), 'time', var_id)
      status = nf90_get_var(ncid(j), var_id, time(is:ie)) 
      status = nf90_inq_varid(ncid(j), NCNAME1, var_id)
      status = nf90_get_var(ncid(j), var_id, data1(is:ie))
      status = nf90_inq_varid(ncid(j), NCNAME2, var_id)
      status = nf90_get_var(ncid(j), var_id, data2(is:ie))
      status = nf90_close(ncid(j))
    end do
    deallocate( num_d )
    deallocate( ncid )

  end subroutine read_infiles_nc2


! **********************************************************************

  subroutine read_infiles_wave(Num_file, FILE_NAME, Num_header    &
             , Ryear, Rmonth, Rday                                &
             , Num_data, time, Hs_data, Tp_data)

    integer, intent(IN ) :: Num_file
    character(256), intent(IN ) :: FILE_NAME(Num_file)
    integer, intent(IN ) :: Num_header
    integer, intent(IN ) :: Ryear
    integer, intent(IN ) :: Rmonth
    integer, intent(IN ) :: Rday
    integer, intent(OUT) :: Num_data
    real(8), intent(OUT), allocatable :: time(:)
    real(8), intent(OUT), allocatable :: Hs_data(:)
    real(8), intent(OUT), allocatable :: Tp_data(:)

    integer, allocatable :: num_d(:)
    real(8) :: tmp

    allocate( num_d(0:Num_file) )
    Num_data = 0
    num_d(0) = 0
  
    do j=1, Num_file
! ----- Open data ---------------------------------------------
      open(77,file=FILE_NAME(j))     
!  ---- count data number -----
      num_d(j) = 0
      do
        read(77,*,iostat=ios) 
        if(ios==-1) exit
        num_d(j) = num_d(j)+1
      end do
      close(77)
      num_d(j) = num_d(j) - Num_header 
      Num_data = Num_data + num_d(j)
    end do
  
    allocate( time(Num_data) )
    allocate( Hs_data(Num_data) )
    allocate( Tp_data(Num_data) )

    do j=1, Num_file
! ----- Open data ---------------------------------------------
      open(77,file=FILE_NAME(j))     
        
!  ---- Read data -----
      do i=1, Num_header
        read(77,*)
      end do

      do i=num_d(j-1)+1, num_d(j)+num_d(j-1)
        read(77,*) tmp, Hs_data(i), Tp_data(i)
#ifdef INPUT_SWAN
!  ---- Convert format from swan time to roms ocean time -----
        tmp = tmp + 0.00000001  !! For error handling
        CALL convert_time_swan2roms(tmp, Ryear, Rmonth, Rday, time(i))
#else
        time(i) =tmp
#endif  
!        write(96,*)  tmp, time(i), Hs_data(i), Tp_data(i)
      end do
      close(77)
    end do
    deallocate( num_d )

  end subroutine read_infiles_wave

! **********************************************************************
  subroutine convert_time_swan2roms(swan_time, Ryear, Rmonth, Rday, roms_time)
    USE mod_calendar

    real(8), intent(IN )  :: swan_time
    integer, intent(IN )  :: Ryear
    integer, intent(IN )  :: Rmonth
    integer, intent(IN )  :: Rday
    real(8), intent(OUT)  :: roms_time
    integer :: yr, mon, day, hr, min, sec
    integer :: days


    yr  = floor( swan_time/10000.0d0 )
    mon = floor( (swan_time - dble(yr)*10000.0d0)/100.0d0 )
    day = floor( (swan_time - dble(yr)*10000.0d0- dble(mon)*100.0d0) )
    hr  = floor( (swan_time-floor(swan_time))*100.0d0 )
    min = floor( (swan_time-floor(swan_time))*10000.0d0 - dble(hr)*100.0d0 )
    sec = floor( (swan_time-floor(swan_time))*1000000.0d0   &
                 - dble(hr)*10000.0d0 - dble(min)*100.0d0 )

    CALL ndays(mon, day, yr, Rmonth, Rday, Ryear, days)

    roms_time = dble(days) + dble(hr)/24.0d0 + dble(min)/1440.0d0 &
                     + dble(sec)/86400.0d0

  end subroutine convert_time_swan2roms
  

! **********************************************************************
!  Read chamber condition data file
! **********************************************************************

  subroutine read_chambercondition
  
    USE mod_param
    
    implicit none
    
    integer, parameter :: N_rep = 5    ! Repeat number of same light condition
    integer :: N_data
    integer :: ios
    
    real(8), parameter :: c1 = -2.9339d-3
    real(8), parameter :: c2 = 10.326d0
    real(8), parameter :: c3 = -8787.5d0
    integer :: i,j
!
      
! ===== READ PPFD data ======================================================
!         time (hour), PPFD (umol m-2 s-1)
#if defined CHAMBER_SITE4
    open(77,file='./input/pfd_04.txt')
#elif defined CHAMBER_SITE5
    open(77,file='./input/pfd_05.txt')
#elif defined CHAMBER_SITE6
    open(77,file='./input/pfd_06.txt')
#elif defined CHAMBER_SITE7
    open(77,file='./input/pfd_07.txt')
#elif defined CHAMBER_SITE9
    open(77,file='./input/pfd_09.txt')
#elif defined CHAMBER_SITE10
    open(77,file='./input/pfd_10.txt')
#endif
! ----- Count data -----
!    N_PFD = 0
!    do
!      read(77,*,iostat=ios)
!      if(ios==-1) exit
!      N_PFD = N_PFD + 1
!    end do
!    allocate( PFD_time(N_PFD*N_rep), PFD_data(N_PFD*N_rep) )   ! Repeat same light condition for 5 times
!    rewind(77) 
!! ----- Read data -----
!    do j=1, N_rep
!      do i=1, N_PFD
!        read(77,*) PFD_time(i+N_PFD*(j-1)), PFD_data(i+N_PFD*(j-1))
!        if(j >= 2) then
!          PFD_time(i+N_PFD*(j-1)) = PFD_time(i+N_PFD*(j-1)) + PFD_time(N_PFD)*dble(j-1)
!        end if
!      end do
!      rewind(77) 
!    end do
!    N_PFD = N_PFD*N_rep
!    close(77)

! ===== READ TA and DIC data =================================================
!         time (hour), TA & DIC (umol kg-1)
#if defined CHAMBER_SITE4
    open(77,file='./input/site04.txt')
#elif defined CHAMBER_SITE5
    open(77,file='./input/site05.txt')
#elif defined CHAMBER_SITE6
    open(77,file='./input/site06.txt')
#elif defined CHAMBER_SITE7
    open(77,file='./input/site07.txt')
#elif defined CHAMBER_SITE9
    open(77,file='./input/site09.txt')
#elif defined CHAMBER_SITE10
    open(77,file='./input/site10.txt')
#endif
! ----- Count data -----
    N_WQ = 0
    do
      read(77,*,iostat=ios)
      if(ios==-1) exit
      N_WQ = N_WQ + 1
    end do
    allocate( WQ_time(N_WQ), TA_data(N_WQ), DIC_data(N_WQ), DO_data(N_WQ) )
    rewind(77) 
! ----- Read data -----
    do i=1, N_WQ
      read(77,*) WQ_time(i), TA_data(i), DIC_data(i)
      WQ_time(i) = WQ_time(i) + 4.0d0*24.0d0
      
      if( DIC_data(i) > -0.25d0*c2/c1) then
        DO_data(i) = c1*DIC_data(i)*DIC_data(i) + c2*DIC_data(i) + c3
      else
        DO_data(i) = -(c2*c2-4.0d0*c1*c3)*0.25/c1
      end if
    end do
    close(77)
    
    return

  end subroutine read_chambercondition

!
! **********************************************************************
!  Set environmental condition
! **********************************************************************

  subroutine setdata(nSetting, in_file)
!   Setting of condition (nSetting)
!
!   nSetting = 1: Stable condition
!              2: Closed chamber condition
!              3: Constant flow condition
!              4: Reef simulation condition
!              5: Incubation chamber condition
  
    USE mod_param
    
    implicit none
    
    integer, intent(IN ) :: nSetting
    integer, intent(IN ) :: in_file(12)

    integer :: id_tmp

! -- Set solar radiation data -----------------------------------------------
    if(in_file(iswrad)>0) then
      CALL lin_interpol(time, swrad_time, swrad_data, num_swrad, swrad, id_swrad)   !data from file
    else
#if defined ANA_SWRAD_LIGHT_DARK
!      swrad=solar_radi(time,1400.d0,0.d0)!9.d0/24.d0)                !Artificial solar radiation

!      swrad=light_and_dark(time, 140.0d0, 10./60./24., 0.5/60./24.)   !light and dark method 10 min interval
!      swrad=light_and_dark(time, 350.0d0, 30./60./24., 0.5/60./24.)   !light and dark method 1 hour interval

!      swrad=light_and_dark2(time, 0.0d0, 3.0d0/24.0d0, 21.0d0/24.0d0, 0.5d0/60.0d0/24.0d0)   !light and dark method 1 hour interval
!      swrad=light_and_dark2(time, 100.0d0, 3.0d0/24.0d0, 21.0d0/24.0d0, 0.5d0/60.0d0/24.0d0)   !light and dark method 1 hour interval
!      swrad=light_and_dark2(time, 250.0d0, 3.0d0/24.0d0, 21.0d0/24.0d0, 0.5d0/60.0d0/24.0d0)   !light and dark method 1 hour interval
      swrad=light_and_dark2(time, 500.0d0, 3.0d0/24.0d0, 21.0d0/24.0d0, 0.5d0/60.0d0/24.0d0)   !light and dark method 1 hour interval
!      swrad=light_and_dark2(time, 1000.0d0, 3.0d0/24.0d0, 21.0d0/24.0d0, 0.5d0/60.0d0/24.0d0)   !light and dark method 1 hour interval

#elif defined ANA_SWRAD_TAKAHASHI_ET_AL_2004
! --- Takahashi et al. (2004) experiment ----------------------
!      swrad=light_and_dark3(time, 3.0d0/24.0d0, 21.0d0/24.0d0, 0.5d0/60.0d0/24.0d0)   !light and dark method 1 hour interval
!      swrad=light_and_dark2(time, 0.0d0, 3.0d0/24.0d0, 21.0d0/24.0d0, 0.5d0/60.0d0/24.0d0)   !light and dark method 1 hour interval
!      swrad=light_and_dark2(time, 100.0d0, 3.0d0/24.0d0, 21.0d0/24.0d0, 0.5d0/60.0d0/24.0d0)   !light and dark method 1 hour interval
!      swrad=light_and_dark2(time, 250.0d0, 3.0d0/24.0d0, 21.0d0/24.0d0, 0.5d0/60.0d0/24.0d0)   !light and dark method 1 hour interval
!      swrad=light_and_dark2(time, 500.0d0, 3.0d0/24.0d0, 21.0d0/24.0d0, 0.5d0/60.0d0/24.0d0)   !light and dark method 1 hour interval

!      swrad=light_and_dark4(time, 1050.0d0, 3.0d0/24.0d0)   !light and dark method 1 hour interval
!      swrad=light_and_dark4(time, 520.0d0, 3.0d0/24.0d0)   !light and dark method 1 hour interval
!      swrad=light_and_dark4(time, 260.0d0, 3.0d0/24.0d0)   !light and dark method 1 hour interval
!      swrad=light_and_dark4(time, 105.0d0, 3.0d0/24.0d0)   !light and dark method 1 hour interval
      swrad=light_and_dark4(time, 0.0d0, 3.0d0/24.0d0)   !light and dark method 1 hour interval
#elif defined ANA_SWRAD_ZILLMAN
!      swrad=short_radi(time, 0.0d0, 1.0d0, 24.0d0, 25.0d0, 50.0d0, 1) !shortwave radiation by Zillman equation
      swrad=short_radi(time, 0.0d0, 77.0d0, 24.0d0, 27.0d0, 50.0d0, 2) !shortwave radiation around 3/21 by Zillman equation
!      swrad=short_radi(time, 0.0d0, 77.0d0, 24.0d0, 27.0d0, 50.0d0, 2)*0.25d0 !shortwave radiation around 3/21 by Zillman equation
!      swrad=short_radi(time, 0.0d0, 77.0d0, 24.0d0, 27.0d0, 50.0d0, 2)*0.5d0 !shortwave radiation around 3/21 by Zillman equation
#endif    
    endif
! -- Set dlwrad data -----------------------------------------------
    if(in_file(idlwrad)>0) then
      CALL lin_interpol(time, dlwrad_time, dlwrad_data, num_dlwrad, dlwrad, id_dlwrad)   !data from file
    else
      dlwrad = 300.0d0
    endif
! -- Set Tair data -----------------------------------------------
    if(in_file(iTair)>0) then
      CALL lin_interpol(time, Tair_time, Tair_data, num_Tair, Tair, id_Tair)   !data from file
    else
      Tair = 25.0d0
    endif
! -- Set Pair data -----------------------------------------------
    if(in_file(iPair)>0) then
      CALL lin_interpol(time, Pair_time, Pair_data, num_Pair, Pair, id_Pair)   !data from file
    else
      Pair = 1013.0d0
    endif
! -- Set wind data -----------------------------------------------
    if(in_file(iwind)>0) then
      id_tmp = id_wind
      CALL lin_interpol(time, wind_time, Uwind_data, num_wind, Uwind, id_tmp  )   !data from file
      CALL lin_interpol(time, wind_time, Vwind_data, num_wind, Vwind, id_wind )   !data from file
    else
      Uwind = 0.0d0
      Vwind = 0.0d0
    endif
! -- Set rain data -----------------------------------------------
    if(in_file(irain)>0) then
      CALL lin_interpol(time, rain_time, rain_data, num_rain, rain, id_rain)   !data from file
    else
      rain = 0.0d0
    endif
! -- Set Rh data -----------------------------------------------
    if(in_file(iRh)>0) then
      CALL lin_interpol(time, Rh_time, Rh_data, num_Rh, Rh, id_Rh)   !data from file
    else
      Rh = 80.0d0
    endif
! -- Set cloud data -----------------------------------------------
    if(in_file(icloud)>0) then
      CALL lin_interpol(time, cloud_time, cloud_data, num_cloud, cloud, id_cloud)   !data from file
    else
      cloud = 0.0d0
    endif
! -- Set PPFD data -----------------------------------------------
    if(in_file(iPFD)>0) then
      CALL lin_interpol(time, PFD_time, PFD_data, num_PFD, PFD, id_PFD)   !data from file
    else
!   Convert solar radiation (W m-2) to photosynthetic photon flux 
!   density: 2.1 umol m-2 s-1 per W m-2 (Britton and Dodd 1976)
!   Sea surface albedo: 0.07
      PFD = 2.1d0 * swrad*(1.0d0-0.07d0)
    endif
! -- Set wtemp data -----------------------------------------------
    if(in_file(iwtemp)>0) then
      CALL lin_interpol(time, wtemp_time, wtemp_data, num_wtemp, wtemp, id_wtemp)   !data from file
      if(nSetting==4) then
        t(2,:,:,:,iTemp) = wtemp
      else
        t(1,:,:,:,iTemp) = wtemp
      endif
    else
      wtemp = 25.0d0
    endif
! -- Set tide data -----------------------------------------------
    if(in_file(itide)>0) then
      CALL lin_interpol(time, tide_time, tide_data, num_tide, tide, id_tide)   !data from file
    else
      tide = 0.0d0
    endif
! -- Set wave data -----------------------------------------------
    if(in_file(iwv)>0) then
      id_tmp = id_wv
      CALL lin_interpol(time, wv_time, Hs_data, num_wv, Hs, id_tmp)   !data from file
      CALL lin_interpol(time, wv_time, Tp_data, num_wv, Tp, id_wv )   !data from file
    else
      Hs = 1.0d0
      Tp = 8.0d0
    endif

    PFDsurf = PFD
!----- Flux calculation -----------------------------------------

!    tau = 1024*0.01*0.0**2. *0.5 !densSW*Cd*Ub**2    (0 cm s-1)
!    tau = 1024*0.01*0.02**2. *0.5  !densSW*Cd*Ub**2  (2 cm s-1)
    tau = 1024*0.01*0.01**2. *0.5  !densSW*Cd*Ub**2  (1 cm s-1)
!    tau = 1024*0.01*0.2**2. *0.5  !densSW*Cd*Ub**2  (20 cm s-1)

!    tau = 1024*0.14*0.02**2. *0.5  !densSW*Cd*Ub**2  (2 cm s-1)
!    tau = 1024*0.14*0.05**2. *0.5  !densSW*Cd*Ub**2  (5 cm s-1)
!    tau = 1024*0.14*0.10**2. *0.5  !densSW*Cd*Ub**2  (10 cm s-1)

!    tau = 1024*0.01*0.2**2. *0.5 !densSW*Cd*Ub**2   (20 cm s-1)
    
    pCO2air = 400.0d0 !(uatm)
    
    U10 = SQRT( Uwind*Uwind + Vwind*Vwind )
    
    fvol_pre =0.0d0 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
      
    return

  end subroutine setdata

    
! **********************************************************************

  subroutine lin_interpol(time,t_data,d_data,N_data, out_data, i_data)

    implicit none

!    real lin_interpol
    real(8), intent(in ) :: time           ! progress time
    real(8), intent(in ) :: t_data(N_data) ! Data time
    real(8), intent(in ) :: d_data(N_data) ! Data value
    integer, intent(in ) :: N_data         ! Number of data
    real(8), intent(out) :: out_data       ! Interpolated value
    integer, intent(inout) :: i_data       ! Index of current data

    real(8) :: dt
    integer ::  i,j

    do i=i_data, N_data-1
      if( t_data(i+1)>=time .and. t_data(i+1)>t_data(i) ) exit
    end do
    if(i+1.gt.N_data) then
      out_data = d_data(i)
    else
      dt = t_data(i+1)-t_data(i)
      out_data = d_data(i)+(d_data(i+1)-d_data(i)) * (time-t_data(i))/dt
    end if
    i_data = i

    return

  end subroutine lin_interpol

  real(8) function solar_radi(time,PFD,start_time)
! **********************************************************************
! *                                                                    *
! * FUNCTION    :  caliculate solar radiation (W/m2).                  *
! *              time:       progress time (day)                       *
! *              start_time: start time (day)                          *
! *                 ex.) 0:00-> start_time=0; 12:00-> start_time=0.5   *
! *                                                                    *
! **********************************************************************

    implicit none
    
    real(8), parameter :: pi = 3.141592654d0

    real(8) time, PFD,start_time

!    solar_radi=PFD/4.57*sin(2.*pi*(time+start_time-0.25))
    solar_radi=PFD/1.82d0*sin(2.*pi*(time+start_time-0.25))
                    !convert photon flux density (umol m-2 s-1) to solar radiation (W m-2)

    if(solar_radi.lt.0.) then
      solar_radi=0.
    endif

    return

  end function solar_radi


  real(8) function short_radi( time,start_time,start_day, lat   &
                              ,temp,Hum, mode )
! **********************************************************************
! *                                                                    *
! * FUNCTION    :  Caliculate short wave radiation (W/m2).             *
! *                 by Zillman equation                                *
! *                                                                    *
! *              time:       progress time (day)                       *
! *              start_time: start time (day)                          *
! *                 ex.) 0:00-> start_time=0; 12:00-> start_time=0.5   *
! *              start_day:  start day (day)                           *
! *                 ex.) Jan. 1-> start_day=1; Jun 22-> start_day=174  *
! *                                                                    *
! *              lat: latitude (degree)                                *
! *              Hum: rerative humidity (%)                            *
! *              temp: temperature (degree C)                          *
! *                                                                    *
! *              Hum: rerative humidity (%)                            *
! *                                                                    *
! *              mode: mode =1 -> day time progress                    *
! *                    mode =2 -> loop same day condition              *
! *                                                                    *
! **********************************************************************
!
    implicit none
    
    real(8), parameter :: pi = 3.141592654d0
    real(8), parameter :: Sc = 1353.0d0        !Solar constant (W m-2)

    real(8) :: time, start_time,lat,temp, Hum
    integer :: mode
    real(8) :: start_day
    real(8) :: yDay !day of year
    real(8) :: cosZ
    real(8) :: DA    !DA=2.*pi*yDay/365.
    real(8) :: e_vep !vapor pressure (Pa)
    real(8) :: dec   !declination (radian)
    real(8) :: HA    !hour angle (radian)
    real(8) :: lati
    integer :: i

    e_vep=611.*10.**(7.5*(temp/(temp+273.15-35.86))) * Hum/100.

    HA=(0.5-time)*2.*pi

    if(mode .eq. 1) then
      yDay=start_day+Int(time) ! day time progress
    else
      yDay=start_day            ! light condition releated same day.
    endif
    
    yDay=mod(yDay-1.,365.)+1.

    dec=23.44*cos((172.-yDay)*2.*pi/365.) *pi/180.
!    DA=2.*pi*yDay/365.
!    dec=0.006918-0.399912*cos(DA)   +0.070257*sin(DA)
!               -0.006758*cos(2.*DA)+0.000907*sin(2.*DA)
!               -0.002697*cos(3.*DA)+0.001480*sin(3.*DA)
!
    lati=lat *pi/180. !degree -> radian

    cosZ=sin(lati)*sin(dec)+cos(lati)*cos(dec)*cos(HA)



    if(cosZ.lt.0.) then
      short_radi=0.
    else
      short_radi=Sc*cosZ**2./((cosZ+2.7)*e_vep*1.e-5 + 1.085*cosZ +0.10)
    endif

    return

  end function short_radi


  real(8) function light_and_dark(time,PFD,interval,transperi)
! **********************************************************************
! *                                                                    *
! * FUNCTION    :  caliculate solar radiation (W/m2).                  *
! *              time:       progress time (day)                       *
! *              interval: interval of light & dark (day)              *
! *              transperi: transition period between light & dark (day)*
! *                                                                    *
! **********************************************************************
!
    implicit none
    
    real(8), parameter :: pi = 3.141592654d0

    real(8) :: time, PFD,interval, transperi
    real(8) :: Imax   !light intensity (W/m2)

!          !convert photon flux density (umol m-2 s-1) to solar radiation (W m-2)
    Imax = PFD/4.57 ! for Al-Horani et al. (2003) experiment
!    Imax = 350./4.57 ! for Kuhl et al. (1995) experiment                      

!  Dark->light->Dark->light

!    if(mod(time,interval*2.).lt.interval) then
!      if(mod(time,interval*2.).lt.transperi) then
!        light_and_dark=
!               Imax/2.*(Cos(pi*mod(time,interval*2.)/transperi)+1.)
!      else
!        light_and_dark=0.
!      endif
!    else
!      if(mod(time,interval*2.).lt.interval+transperi) then
!        light_and_dark=
!              Imax/2.*(-Cos(pi*(mod(time,interval*2.)-interval)
!                                 /transperi)+1.)
!      else
!        light_and_dark= Imax
!      endif    
!    endif


!  light->Dark->light->Dark

    if(mod(time,interval*2.).lt.interval) then
      if(mod(time,interval*2.).lt.transperi) then
        light_and_dark=                                         &
              Imax/2.*(-Cos(pi*(mod(time,interval*2.)-interval) &
                                 /transperi)+1.)
      else
        light_and_dark= Imax
      endif
    else
      if(mod(time,interval*2.).lt.interval+transperi) then
        light_and_dark=                                            &
               Imax/2.*(Cos(pi*mod(time,interval*2.)/transperi)+1.)
      else
        light_and_dark=0.

      endif    
    endif

    return

  end function light_and_dark

  real(8) function light_and_dark2(time,PFD,interval1,interval2,transperi)
! **********************************************************************
! *                                                                    *
! * FUNCTION    :  caliculate solar radiation (W/m2).                  *
! *              time:       progress time (day)                       *
! *              interval: interval of light & dark (day)              *
! *              transperi: transition period between light & dark (day)*
! *                                                                    *
! **********************************************************************
!
    implicit none
    
    real(8), parameter :: pi = 3.141592654d0

    real(8) :: time, PFD,interval1,interval2, transperi
    real(8) :: Imax   !light intensity (W/m2)

!            !convert photon flux density (umol m-2 s-1) to solar radiation (W m-2)
    Imax = PFD/2.1d0/(1.0d0-0.07d0) ! for Takahashi et al. (2004) experiment

!  light->Dark->light

    if(mod(time,interval1+interval2)<=interval2) then
      if(mod(time,interval1+interval2)<=transperi) then
        light_and_dark2=                                         &
              Imax/2.*(Cos(pi*(mod(time,interval1+interval2)-interval1) &
                                 /transperi)+1.)
      else
        light_and_dark2 = 20.0d0/2.1d0/(1.0d0-0.07d0)
      endif
    else
      if(mod(time,interval1+interval2)<=interval1+transperi) then
        light_and_dark2=                                            &
               Imax/2.*(-Cos(pi*mod(time,interval1+interval2)/transperi)+1.)
      else
        light_and_dark2 = Imax

      endif    
    endif

    return

  end function light_and_dark2

  real(8) function light_and_dark3(time,interval1,interval2,transperi)
! **********************************************************************
! *                                                                    *
! * FUNCTION    :  caliculate solar radiation (W/m2).                  *
! *              time:       progress time (day)                       *
! *              interval: interval of light & dark (day)              *
! *              transperi: transition period between light & dark (day)*
! *                                                                    *
! **********************************************************************
!
    implicit none
    
    real(8), parameter :: pi = 3.141592654d0

    real(8) :: time, interval1,interval2, transperi
    real(8) :: Imax   !light intensity (W/m2)
    real(8) :: PFD

!            !convert photon flux density (umol m-2 s-1) to solar radiation (W m-2)
    if (time <= 1.1d0) then
      PFD = 1000.0d0
    else if (time <= 2.1d0) then
      PFD = 0.0d0
    else if (time <= 3.1d0) then
      PFD = 250.0d0
    else if (time <= 4.1d0) then
      PFD = 500.0d0
    else if (time <= 5.1d0) then
      PFD = 1000.0d0
    else
      PFD = 1000.0d0
    endif
    
    Imax = PFD/2.1d0/(1.0d0-0.07d0) ! for Takahashi et al. (2004) experiment

!  Dark->light->Dark->light

    if(mod(time,interval1+interval2)<=interval2) then
      if(mod(time,interval1+interval2)<=transperi) then
        light_and_dark3=                                         &
              Imax/2.*(Cos(pi*(mod(time,interval1+interval2)-interval1) &
                                 /transperi)+1.)
      else
        light_and_dark3= 20.0d0/2.1d0/(1.0d0-0.07d0)
      endif
    else
      if(mod(time,interval1+interval2)<=interval1+transperi) then
        light_and_dark3=                                            &
               Imax/2.*(-Cos(pi*mod(time,interval1+interval2)/transperi)+1.)
      else
        light_and_dark3=Imax

      endif    
    endif

    return

  end function light_and_dark3

  real(8) function light_and_dark4(time,PFD,interval)
! **********************************************************************
! *                                                                    *
! * FUNCTION    :  caliculate solar radiation (W/m2).                  *
! *              time:       progress time (day)                       *
! *              interval: interval of light & dark (day)              *
! *              transperi: transition period between light & dark (day)*
! *                                                                    *
! **********************************************************************
!
    implicit none
    
    real(8), parameter :: pi = 3.141592654d0

    real(8) :: time, PFD,interval
    real(8) :: Imax   !light intensity (W/m2)

!          !convert photon flux density (umol m-2 s-1) to solar radiation (W m-2)
    Imax = PFD/2.1d0/(1.0d0-0.07d0) ! for Al-Horani et al. (2003) experiment

!  light->Dark->light->Dark

    if(time.lt.interval) then
      light_and_dark4= Imax
    else
      light_and_dark4=20.0/2.1d0/(1.0d0-0.07d0)
    endif

    return

  end function light_and_dark4

      
end module mod_input

