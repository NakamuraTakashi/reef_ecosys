
!!!=== Copyright (c) 2024 Takashi NAKAMURA  =====

!!!**** netCDF output MODULE ************************************

MODULE mod_output_nc
  
  use netcdf
#if defined FOODWEB
  use mod_foodweb, ONLY : Ndom, Npom, Nphy, Nzoo, Npim
#endif

  implicit none  

  integer, parameter :: N_var = 36

  character(256), parameter :: VAR_NAME(N_var) = (/ &
     "zeta          " &  !  1
    ,"u             " &  !  2 
    ,"v             " &  !  3
    ,"ubar          " &  !  4 
    ,"vbar          " &  !  5 
    ,"temp          " &  !  6 
    ,"salt          " &  !  7 
    ,"mud_          " &  !  8 
    ,"sand_         " &  !  9
    ,"TIC           " &  ! 10
    ,"alkalinity    " &  ! 11
    ,"oxygen        " &  ! 12
    ,"DOC_          " &  ! 13
    ,"POC_          " &  ! 14
    ,"phytoplankton_" &  ! 15
    ,"zooplankton_  " &  ! 16
    ,"PIC_          " &  ! 17
    ,"NO3           " &  ! 18
    ,"NH4           " &  ! 19
    ,"PO4           " &  ! 20
    ,"DON_          " &  ! 21
    ,"PON_          " &  ! 22
    ,"DOP_          " &  ! 23
    ,"POP_          " &  ! 24
    ,"TI13C         " &  ! 25
    ,"DO13C_        " &  ! 26
    ,"PO13C_        " &  ! 27
    ,"phyt13C_      " &  ! 28
    ,"zoop13C_      " &  ! 29
    ,"PI13C_        " &  ! 30
    ,"15NO3         " &  ! 31
    ,"15NH4         " &  ! 32
    ,"DO15N_        " &  ! 33
    ,"PO15N_        " &  ! 34
    ,"phyt15N_      " &  ! 35
    ,"zoop15N_      " &  ! 36
     /)
  character(256), parameter :: VAR_NAME2(N_var) = (/ &
     "zeta          " &  !  1
    ,"u             " &  !  2 
    ,"v             " &  !  3
    ,"ubar          " &  !  4 
    ,"vbar          " &  !  5 
    ,"temp          " &  !  6 
    ,"salt          " &  !  7 
    ,"mud_          " &  !  8 
    ,"sand_         " &  !  9
    ,"TIC           " &  ! 10
    ,"alkalinity    " &  ! 11
    ,"Oxyg          " &  ! 12
    ,"DOC_          " &  ! 13
    ,"POC_          " &  ! 14
    ,"Phyt_         " &  ! 15
    ,"Zoop_         " &  ! 16
    ,"PIC_          " &  ! 17
    ,"NO3           " &  ! 18
    ,"NH4           " &  ! 19
    ,"PO4           " &  ! 20
    ,"DON_          " &  ! 21
    ,"PON_          " &  ! 22
    ,"DOP_          " &  ! 23
    ,"POP_          " &  ! 24
    ,"d13C_TIC      " &  ! 25
    ,"d13C_DOC_     " &  ! 26
    ,"d13C_POC_     " &  ! 27
    ,"d13C_Phyt_    " &  ! 28
    ,"d13C_Zoop_    " &  ! 29
    ,"PI13C_        " &  ! 30
    ,"d15N_NO3      " &  ! 31
    ,"d15N_NH4      " &  ! 32
    ,"d15N_DON_     " &  ! 33
    ,"d15N_PON_     " &  ! 34
    ,"d15N_Phyt_    " &  ! 35
    ,"d15N_Zoop_    " &  ! 36
     /)
  character(256), parameter :: VAR_LONG_NAME(N_var) = (/ &
     "free-surface                                " &
    ,"u-momentum component                        " &
    ,"v-momentum component                        " &
    ,"vertically integrated u-momentum component  " &
    ,"vertically integrated v-momentum component  " &
    ,"potential temperature                       " &
    ,"salinity                                    " &
    ,"suspended cohesive sediment                 " &
    ,"suspended noncohesive sediment              " &
    ,"total inorganic carbon                      " &
    ,"total alkalinity                            " &
    ,"dissolved oxygen concentration              " &
    ,"dissolved organic carbon                    " &
    ,"particulate organic carbon                  " &
    ,"phytoplankton                               " &
    ,"zooplankton                                 " &
    ,"particulate inorganic carbon                " &
    ,"nitrate concentration                       " &
    ,"ammonium concentration                      " &
    ,"phosphate concentration                     " &
    ,"dissolved organic nitrogen concentration    " &
    ,"particulate organic nitrogen concentration  " &
    ,"dissolved organic phosphorus concentration  " &
    ,"particulate organic phosphorus concentration" &
    ,"carbon 13 of total inorganic carbon         " &
    ,"carbon 13 of DOC                            " &
    ,"carbon 13 of POC                            " &
    ,"carbon 13 of phytoplankton                  " &
    ,"carbon 13 of zooplankton                    " &
    ,"carbon 13 of PIC                            " &
    ,"nitrogen 15 of nitrate                      " &
    ,"nitrogen 15 of ammonium                     " &
    ,"nitrogen 15 of DON                          " &
    ,"nitrogen 15 of PON                          " &
    ,"nitrogen 15 of phytoplankton                " &
    ,"nitrogen 15 of zooplankton                  " &
    /)
  character(256), parameter :: VAR_UNIT(N_var) = (/ &
     "meter           " &
    ,"meter second-1  " &
    ,"meter second-1  " &
    ,"meter second-1  " &
    ,"meter second-1  " &
    ,"Celsius         " &
    ,"nondimensional  " &
    ,"kilogram meter-3" &
    ,"kilogram meter-3" &
    ,"umol kg-1       " &
    ,"umol kg-1       " &
    ,"oxygen          " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    ,"umol L-1        " &
    /)

  character(256), parameter :: SED_NAME(15) = (/ &
     "mudfrac_      " &  !  1
    ,"mudmass_      " &  !  2 
    ,"sandfrac_     " &  !  3
    ,"sandmass_     " &  !  4 
    ,"bed_thickness " &  !  5 
    ,"bed_age       " &  !  6 
    ,"bed_porosity  " &  !  7 
    ,"bed_biodiff   " &  !  8 
    ,"grain_diameter" &  !  9 
    ,"grain_density " &  ! 10 
    ,"settling_vel  " &  ! 11 
    ,"erosion_stress" &  ! 12 
    ,"ripple_length " &  ! 13 
    ,"ripple_height " &  ! 14 
    ,"Zo_def        " &  ! 15 
     /)
  character(256), parameter :: SED_LONGNAME(15) = (/ &
     "cohesive sediment fraction             " &  !  1
    ,"cohesive sediment mass                 " &  !  2 
    ,"snoncohesive sediment fraction         " &  !  3
    ,"noncohesive sediment mass              " &  !  4 
    ,"sediment bed layer thickness           " &  !  5 
    ,"sediment layer age                     " &  !  6 
    ,"sediment layer porosity                " &  !  7 
    ,"biodiffusivity at bottom of each layer " &  !  8 
    ,"sediment median grain diameter size    " &  !  9 
    ,"sediment median grain density          " &  ! 10 
    ,"sediment median grain settling velocity" &  ! 11 
    ,"sediment median critical erosion stress" &  ! 12 
    ,"bottom ripple length                   " &  ! 13 
    ,"bottom ripple height                   " &  ! 14 
    ,"default bottom roughness length        " &  ! 15 
     /)
  character(256), parameter :: SED_UNIT(15) = (/ &
     "nondimensional  " &  !  1
    ,"kilogram meter-2" &  !  2 
    ,"nondimensional  " &  !  3
    ,"kilogram meter-2" &  !  4 
    ,"meter           " &  !  5 
    ,"seconds         " &  !  6 
    ,"nondimensional  " &  !  7 
    ,"meter2 second-1 " &  !  8 
    ,"meter           " &  !  9 
    ,"kilogram meter-3" &  ! 10 
    ,"meter second-1  " &  ! 11 
    ,"newton meter-2  " &  ! 12 
    ,"meter           " &  ! 13 
    ,"meter           " &  ! 14 
    ,"meter           " &  ! 15 
     /)

  CONTAINS
!
!**** Create initial conditions NetCDF file **********************************************

    SUBROUTINE createNetCDFini2( &
!        input parameters
            IN_FILE              &
          , OUT_FILE             &
          , TIME_ATT             &  
          , Nxr, Nyr, Nzr, Nt    &   
          , name_flag            &   
!        Output parameters
          , Nbed, NCS, NNS       &   
          )
                               
!    input parameters
      character(len=*),  intent( in) :: IN_FILE
      character(len=*),  intent( in) :: OUT_FILE
      character(len=*),  intent( in) :: TIME_ATT
      integer, intent( in) :: Nxr, Nyr, Nzr, Nt
      integer, intent( in) :: name_flag( N_var )
      integer, intent(out) :: Nbed ! Number of sediment bed layers
      integer, intent(out) :: NCS  ! Number of cohesive (mud) sediment tracers
      integer, intent(out) :: NNS  ! Number of non-cohesive (sand) sediment tracers
      character(256) :: varname
      character(2) :: varnum

      integer :: ncid,var_id, ncid2,var_id2
!      integer :: lat_dimid, lon_dimid, depth_dimid, time_dimid
      integer :: xr_dimid, yr_dimid
      integer :: xu_dimid, yu_dimid
      integer :: xv_dimid, yv_dimid
      integer :: zr_dimid, zw_dimid
      integer :: t_dimid
      integer :: zb_dimid
      integer :: status
      integer, allocatable :: dimids(:)
      integer :: i,j

!---- Initialize  --------------------------------

      Nbed=0
      NCS=0
      NNS=0

!---- Create the ROMS initial condition netCDF file --------------------------------

      write(*,*) "CREATE: ", trim( OUT_FILE )

      call check( nf90_create( trim( OUT_FILE ), nf90_clobber, ncid) )

      call check( nf90_def_dim(ncid, 'xi_rho', Nxr, xr_dimid) )
      call check( nf90_def_dim(ncid, 'xi_u', Nxr-1, xu_dimid) )
      call check( nf90_def_dim(ncid, 'xi_v', Nxr, xv_dimid) )
      call check( nf90_def_dim(ncid, 'eta_rho', Nyr, yr_dimid) )
      call check( nf90_def_dim(ncid, 'eta_u', Nyr, yu_dimid) )
      call check( nf90_def_dim(ncid, 'eta_v', Nyr-1, yv_dimid) )
      call check( nf90_def_dim(ncid, 's_rho', Nzr, zr_dimid) )
      call check( nf90_def_dim(ncid, 's_w', Nzr+1, zw_dimid) )
      call check( nf90_def_dim(ncid, 'ocean_time', NF90_UNLIMITED, t_dimid) )
      
    ! Define the netCDF variables.
      call addNetCDFvertical( ncid, zr_dimid, zw_dimid )

      call check( nf90_def_var(ncid, 'ocean_time', NF90_DOUBLE, t_dimid, var_id) )
      call check( nf90_put_att(ncid, var_id, 'long_name', 'time since initialization') )
      call check( nf90_put_att(ncid, var_id, 'units',     TIME_ATT ) )

!      call check( nf90_redef(ncid) )

      call check( nf90_open( trim(IN_FILE), nf90_nowrite, ncid2) )
      do i=1, N_var
        
        if (name_flag( i ) == 0 ) cycle

        if     ( i == 1 ) then  ! zeta
          allocate(dimids(3))
          dimids = (/ xr_dimid, yr_dimid, t_dimid /)
        elseif ( i == 2 ) then  ! u
          allocate(dimids(4))
          dimids = (/ xu_dimid, yu_dimid, zr_dimid, t_dimid /)
        elseif ( i == 3 ) then  ! v
          allocate(dimids(4))
          dimids = (/ xv_dimid, yv_dimid, zr_dimid, t_dimid /)
        elseif ( i == 4 ) then  ! ubar
          allocate(dimids(3))
          dimids = (/ xu_dimid, yu_dimid, t_dimid /)
        elseif ( i == 5 ) then  ! vbar
          allocate(dimids(3))
          dimids = (/ xv_dimid, yv_dimid, t_dimid /)
        else
          allocate(dimids(4))   ! tracers
          dimids = (/ xr_dimid, yr_dimid, zr_dimid, t_dimid /)
        endif

        if( i == 4 ) then  ! ubar
          write(*,*) 'Add variable: ', trim( VAR_NAME(i) )
          call check( nf90_def_var(ncid, trim( VAR_NAME(i) ), NF90_DOUBLE, dimids, var_id) )
          call check( nf90_put_att(ncid, var_id, 'long_name', 'vertically integrated u-momentum component') )
          call check( nf90_put_att(ncid, var_id, 'units',     'meter second-1') )
          call check( nf90_put_att(ncid, var_id, 'time',      'ocean_time') )
        else if( i == 5 ) then  ! vbar
          write(*,*) 'Add variable: ', trim( VAR_NAME(i) )
          call check( nf90_def_var(ncid, trim( VAR_NAME(i) ), NF90_DOUBLE, dimids, var_id) )
          call check( nf90_put_att(ncid, var_id, 'long_name', 'vertically integrated v-momentum component') )
          call check( nf90_put_att(ncid, var_id, 'units',     'meter second-1') )
          call check( nf90_put_att(ncid, var_id, 'time',      'ocean_time') )
        else if( i==8  .or. i==9  .or. i==13 .or. i==14 .or. i==15 .or. i==16 .or.  &
                 i==17 .or. i==21 .or. i==22 .or. i==23 .or. i==24 .or. i==26 .or.  &
                 i==27 .or. i==28 .or. i==29 .or. i==30 .or. i==33 .or. i==34 .or.  &
                 i==35 .or. i==36  ) then  ! mud_, sand_, etc...
           do j=1,99
            write(varnum,'(I2.2)') j
            varname = trim( VAR_NAME(i) )//varnum
            status = nf90_inq_varid(ncid2, trim( varname ), var_id2)
            if (status /= nf90_noerr) exit
            write(*,*) 'Add variable: ', trim( varname )
            call check( nf90_def_var(ncid, trim( varname ), NF90_DOUBLE, dimids, var_id) )
            call check( nf90_copy_att(ncid2, var_id2, 'long_name', ncid, var_id) )
            call check( nf90_copy_att(ncid2, var_id2, 'units', ncid, var_id) )
            call check( nf90_copy_att(ncid2, var_id2, 'time', ncid, var_id) )
            if (i==8) NCS=j
            if (i==9) NNS=j
          enddo
        else
          write(*,*) 'Add variable: ', trim( VAR_NAME(i) )
          call check( nf90_inq_varid(ncid2, trim( VAR_NAME(i) ), var_id2) )
          call check( nf90_def_var(ncid, trim( VAR_NAME(i) ), NF90_DOUBLE, dimids, var_id) )
          call check( nf90_copy_att(ncid2, var_id2, 'long_name', ncid, var_id) )
        !  call check( nf90_copy_att(ncid2, var_id2, 'units', ncid, var_id) )
          status = nf90_copy_att(ncid2, var_id2, 'units', ncid, var_id) 
          call check( nf90_copy_att(ncid2, var_id2, 'time', ncid, var_id) )
        endif
        deallocate(dimids)
      enddo

! Add sediment parameters

      if(name_flag(8) == 1 .or. name_flag(9) == 1) then

        call get_dimension(ncid2, 'Nbed', Nbed)
        call check( nf90_def_dim(ncid, 'Nbed', Nbed, zb_dimid) )

        allocate(dimids(4))
        dimids = (/ xr_dimid, yr_dimid, zb_dimid, t_dimid /)

        do i=1, 8
          if(i==1 .or. i==2) then
            do j=1,NCS
              write(varnum,'(I2.2)') j
              varname = trim( SED_NAME(i) )//varnum
              call check( nf90_def_var(ncid, trim( varname ), NF90_DOUBLE, dimids, var_id) )
              call check( nf90_copy_att(ncid2, var_id2, 'long_name', ncid, var_id) )
              status = nf90_copy_att(ncid2, var_id2, 'units', ncid, var_id) 
              call check( nf90_copy_att(ncid2, var_id2, 'time', ncid, var_id) )
            enddo
          elseif(i==3 .or. i==4) then
            do j=1,NNS
              allocate(dimids(4))
              dimids = (/ xr_dimid, yr_dimid, zb_dimid, t_dimid /)
              write(varnum,'(I2.2)') j
              varname = trim( SED_NAME(i) )//varnum
              call check( nf90_def_var(ncid, trim( varname ), NF90_DOUBLE, dimids, var_id) )
              call check( nf90_copy_att(ncid2, var_id2, 'long_name', ncid, var_id) )
              status = nf90_copy_att(ncid2, var_id2, 'units', ncid, var_id) 
              call check( nf90_copy_att(ncid2, var_id2, 'time', ncid, var_id) )
            enddo
          else
            write(*,*) 'Add variable: ', trim( SED_NAME(i) )
            call check( nf90_inq_varid(ncid2, trim( SED_NAME(i) ), var_id2) )
            call check( nf90_def_var(ncid, trim( SED_NAME(i) ), NF90_DOUBLE, dimids, var_id) )
            call check( nf90_copy_att(ncid2, var_id2, 'long_name', ncid, var_id) )
            status = nf90_copy_att(ncid2, var_id2, 'units', ncid, var_id) 
            call check( nf90_copy_att(ncid2, var_id2, 'time', ncid, var_id) )
          endif
        enddo
        deallocate(dimids)

        allocate(dimids(3))
        dimids = (/ xr_dimid, yr_dimid, t_dimid /)
        do i=9, 15
          call check( nf90_def_var(ncid, trim( SED_NAME(i) ), NF90_DOUBLE, dimids, var_id) )
          call check( nf90_put_att(ncid, var_id, 'long_name', trim( SED_LONGNAME(i) ) ) )
          call check( nf90_put_att(ncid, var_id, 'units',     trim( SED_UNIT(i) ) ) )
          call check( nf90_put_att(ncid, var_id, 'time',      'ocean_time') )
        enddo    
        deallocate(dimids)

      endif


  ! End define mode.
      call check( nf90_enddef(ncid) )
      call check( nf90_close(ncid) )
      call check( nf90_close(ncid2) )
      write(*,*) '*** SUCCESS'

    END SUBROUTINE createNetCDFini2
             

!**** Create boundary conditions NetCDF file **********************************************

    SUBROUTINE createNetCDFbry2( &
!        input parameters
            IN_FILE              &
          , OUT_FILE             &
          , TIME_ATT             &  
          , Nxr, Nyr, Nzr, Nt    &   
          , name_flag            &   
          , snwe_flag            &   
      )
                               
!    input parameters
      character(len=*),  intent( in) :: IN_FILE
      character(len=*),  intent( in) :: OUT_FILE
      character(len=*),  intent( in) :: TIME_ATT
      integer, intent( in) :: Nxr, Nyr, Nzr, Nt
      integer, intent( in) :: name_flag( N_var )
      integer, intent( in) :: snwe_flag(4)
      character(256) :: varname, varname2, longname
      character(2) :: varnum

      integer :: ncid,var_id, ncid2,var_id2
!      integer :: lat_dimid, lon_dimid, depth_dimid, time_dimid
      integer :: xr_dimid, yr_dimid
      integer :: xu_dimid, yu_dimid
      integer :: xv_dimid, yv_dimid
      integer :: zr_dimid, zw_dimid
      integer :: t_dimid
      integer :: status
      integer, allocatable :: dimids(:)
      integer :: i,j
      integer :: ibry

!---- Create the ROMS initial condition netCDF file --------------------------------

      write(*,*) "CREATE: ", trim( OUT_FILE )

      call check( nf90_create( trim( OUT_FILE ), nf90_clobber, ncid) )

      call check( nf90_def_dim(ncid, 'xi_rho', Nxr, xr_dimid) )
      call check( nf90_def_dim(ncid, 'xi_u', Nxr-1, xu_dimid) )
      call check( nf90_def_dim(ncid, 'xi_v', Nxr, xv_dimid) )
      call check( nf90_def_dim(ncid, 'eta_rho', Nyr, yr_dimid) )
      call check( nf90_def_dim(ncid, 'eta_u', Nyr, yu_dimid) )
      call check( nf90_def_dim(ncid, 'eta_v', Nyr-1, yv_dimid) )
      call check( nf90_def_dim(ncid, 's_rho', Nzr, zr_dimid) )
      call check( nf90_def_dim(ncid, 's_w', Nzr+1, zw_dimid) )
      call check( nf90_def_dim(ncid, 'bry_time', NF90_UNLIMITED, t_dimid) )
      
    ! Define the netCDF variables.
      call addNetCDFvertical( ncid, zr_dimid, zw_dimid )

      call check( nf90_def_var(ncid, 'bry_time', NF90_DOUBLE, t_dimid, var_id) )
      call check( nf90_put_att(ncid, var_id, 'long_name', 'time since initialization') )
      call check( nf90_put_att(ncid, var_id, 'units',     TIME_ATT ) )

!      call check( nf90_redef(ncid) )

      call check( nf90_open( trim(IN_FILE), nf90_nowrite, ncid2) )
      do i=1, N_var
        
        if ( name_flag( i ) == 0 ) cycle

        do ibry=1,4

          if ( snwe_flag( ibry ) == 0 ) cycle

          if     ( i == 1 ) then  ! zeta
            allocate(dimids(2))
            if(ibry==1 .or. ibry==2 ) then
              dimids = (/ xr_dimid, t_dimid /)
            else
              dimids = (/ yr_dimid, t_dimid /)
            endif
          elseif ( i == 2 ) then  ! u
            allocate(dimids(3))
            if(ibry==1 .or. ibry==2 ) then
              dimids = (/ xu_dimid, zr_dimid, t_dimid /)
            else
              dimids = (/ yu_dimid, zr_dimid, t_dimid /)
            endif
          elseif ( i == 3 ) then  ! v
            allocate(dimids(3))
            if(ibry==1 .or. ibry==2 ) then
              dimids = (/ xv_dimid, zr_dimid, t_dimid /)
            else
              dimids = (/ yv_dimid, zr_dimid, t_dimid /)
            endif
          elseif ( i == 4 ) then  ! ubar
            allocate(dimids(2))
            if(ibry==1 .or. ibry==2 ) then
              dimids = (/ xu_dimid, t_dimid /)
            else
              dimids = (/ yu_dimid, t_dimid /)
            endif
          elseif ( i == 5 ) then  ! vbar
            allocate(dimids(2))
            if(ibry==1 .or. ibry==2 ) then
              dimids = (/ xv_dimid, t_dimid /)
            else
              dimids = (/ yv_dimid, t_dimid /)
            endif
          else
            allocate(dimids(3))   ! tracers
            if(ibry==1 .or. ibry==2 ) then
              dimids = (/ xr_dimid, zr_dimid, t_dimid /)
            else
              dimids = (/ yr_dimid, zr_dimid, t_dimid /)
            endif
          endif
          if( i == 4 .or. i ==5 ) then  ! ubar, vbar
            varname = trim( VAR_NAME(i) )//'_'//trim( BRY_NAME(ibry) )
            write(*,*) 'Add variable: ', trim( varname )
            call check( nf90_def_var(ncid, trim( varname ), NF90_DOUBLE, dimids, var_id) )
            if(i==4) then
              longname = '2D u-momentum '//BRY_LONGNAME(ibry)
            elseif(i==5) then
              longname = '2D v-momentum '//BRY_LONGNAME(ibry)
            else
              longname = trim(longname)//' '//BRY_LONGNAME(ibry)
            endif
            call check( nf90_put_att(ncid, var_id, 'long_name', longname) )
            call check( nf90_put_att(ncid, var_id, 'units',     'meter second-1') )
            call check( nf90_put_att(ncid, var_id, 'time', 'bry_time') )
          else if( i==8  .or. i==9  .or. i==13 .or. i==14 .or. i==15 .or. i==16 .or.  &
                   i==17 .or. i==21 .or. i==22 .or. i==23 .or. i==24 .or. i==26 .or.  &
                   i==27 .or. i==28 .or. i==29 .or. i==30 .or. i==33 .or. i==34 .or.  &
                   i==35 .or. i==36  ) then  ! mud_, sand_, etc...
            do j=1,99
              write(varnum,'(I2.2)') j
              varname2 = trim( VAR_NAME(i) )//varnum
              varname = trim( VAR_NAME(i) )//trim( BRY_NAME(ibry) )//'_'//varnum
              status = nf90_inq_varid(ncid2, trim( varname2 ), var_id2)
              if (status /= nf90_noerr) exit
              write(*,*) 'Add variable: ', trim( varname )
              call check( nf90_def_var(ncid, trim( varname ), NF90_DOUBLE, dimids, var_id) )
              call check( nf90_get_att(ncid2, var_id2, 'long_name', longname) )
              longname = trim(longname)//' '//BRY_LONGNAME(ibry)
              call check( nf90_put_att(ncid, var_id, 'long_name', longname) )
              call check( nf90_copy_att(ncid2, var_id2, 'units', ncid, var_id) )
              call check( nf90_put_att(ncid, var_id, 'time', 'bry_time') )
            enddo
          else
            varname = trim( VAR_NAME(i) )//'_'//trim( BRY_NAME(ibry) )
            write(*,*) 'Add variable: ', trim( varname )
            call check( nf90_inq_varid(ncid2, trim( VAR_NAME(i) ), var_id2) )
            call check( nf90_def_var(ncid, trim( varname ), NF90_DOUBLE, dimids, var_id) )
            call check( nf90_get_att(ncid2, var_id2, 'long_name', longname) )
            if(i==2) then
              longname = 'u-momentum '//BRY_LONGNAME(ibry)
            elseif(i==3) then
              longname = 'v-momentum '//BRY_LONGNAME(ibry)
            else
              longname = trim(longname)//' '//BRY_LONGNAME(ibry)
            endif
            call check( nf90_put_att(ncid, var_id, 'long_name', longname) )
            status = nf90_copy_att(ncid2, var_id2, 'units', ncid, var_id) 
            call check( nf90_put_att(ncid, var_id, 'time', 'bry_time') )
          endif
          deallocate(dimids)

        enddo
      enddo

  ! End define mode.
      call check( nf90_enddef(ncid) )
      call check( nf90_close(ncid) )
      call check( nf90_close(ncid2) )
      write(*,*) '*** SUCCESS'

    END SUBROUTINE createNetCDFbry2

!**** Create river forcing NetCDF file **********************************************

    SUBROUTINE createNetCDFriver( &
!        input parameters
            OUT_FILE              &
          , GLOBAL_ATT            &  
          , TIME_ATT              &  
          , Nriv, Nzr             &   
          , name_flag             &   
          , NCS, NNS              &   
      )
                               
!    input parameters
      character(len=*), intent( in) :: OUT_FILE
      character(len=*), intent( in) :: GLOBAL_ATT
      character(len=*), intent( in) :: TIME_ATT
      integer, intent( in) :: Nriv, Nzr
      integer, intent( in) :: name_flag( N_var )
      integer, intent( in) :: NCS  ! Number of cohesive (mud) sediment tracers  !!! changed for Ando-kun's simulation
      integer, intent( in) :: NNS  ! Number of non-cohesive (sand) sediment tracers

      character(256) :: varname, lvarname
      character(2) :: varnum

      integer :: ncid,var_id
      integer :: zr_dimid
      integer :: riv_dimid
      integer :: t_dimid
      integer :: dim2Dids(2), dim3Dids(3)
      integer :: i,j
      integer :: Ntype

!---- Create the ROMS initial condition netCDF file --------------------------------

      write(*,*) "CREATE: ", trim( OUT_FILE )

      call check( nf90_create( trim( OUT_FILE ), nf90_clobber, ncid) )

      call check( nf90_put_att(ncid, NF90_GLOBAL, 'rivers', trim( GLOBAL_ATT )) )

      call check( nf90_def_dim(ncid, 'river', Nriv, riv_dimid) )
      call check( nf90_def_dim(ncid, 's_rho', Nzr, zr_dimid) )
      call check( nf90_def_dim(ncid, 'river_time', NF90_UNLIMITED, t_dimid) )

      call check( nf90_def_var(ncid, 'river', NF90_DOUBLE, riv_dimid, var_id) )
      call check( nf90_put_att(ncid, var_id, 'long_name', 'river runoff identification number') )

      call check( nf90_def_var(ncid, 'river_time', NF90_DOUBLE, t_dimid, var_id) )
      call check( nf90_put_att(ncid, var_id, 'long_name', 'river runoff time') )
      call check( nf90_put_att(ncid, var_id, 'units',     TIME_ATT ) )

      call check( nf90_def_var(ncid, 'river_direction', NF90_DOUBLE, riv_dimid, var_id) )
      call check( nf90_put_att(ncid, var_id, 'long_name', 'river runoff direction') )
      call check( nf90_put_att(ncid, var_id, 'flag_values', '0, 1') )
      call check( nf90_put_att(ncid, var_id, 'flag_meanings', 'flow across u-face, flow across v-face') )
      call check( nf90_put_att(ncid, var_id, 'LwSrc_True', 'flag not used') )

      call check( nf90_def_var(ncid, 'river_Xposition', NF90_DOUBLE, riv_dimid, var_id) )
      call check( nf90_put_att(ncid, var_id, 'long_name', 'river XI-position') )
      call check( nf90_put_att(ncid, var_id, 'LuvSrc_meaning', 'i point index of U or V face source/sink') )
      call check( nf90_put_att(ncid, var_id, 'LwSrc_meaning', 'i point index of RHO center source/sink') )

      call check( nf90_def_var(ncid, 'river_Eposition', NF90_DOUBLE, riv_dimid, var_id) )
      call check( nf90_put_att(ncid, var_id, 'long_name', 'river ETA-position') )
      call check( nf90_put_att(ncid, var_id, 'LuvSrc_meaning', 'j point index of U or V face source/sink') )
      call check( nf90_put_att(ncid, var_id, 'LwSrc_meaning', 'j point index of RHO center source/sink') )

      dim2Dids = (/ riv_dimid, zr_dimid /)
      call check( nf90_def_var(ncid, 'river_Vshape', NF90_DOUBLE, dim2Dids, var_id) )
      call check( nf90_put_att(ncid, var_id, 'long_name', 'river runoff mass transport vertical profile') )
      call check( nf90_put_att(ncid, var_id, 'requires', 'must sum to 1 over s_rho') )

      dim2Dids = (/ riv_dimid, t_dimid /)
      call check( nf90_def_var(ncid, 'river_transport', NF90_DOUBLE, dim2Dids, var_id) )
      call check( nf90_put_att(ncid, var_id, 'long_name', 'river ETA-position') )
      call check( nf90_put_att(ncid, var_id, 'units', 'meter3 second-1' ) )
      call check( nf90_put_att(ncid, var_id, 'LuvSrc_meaning', 'j point index of U or V face source/sink') )
      call check( nf90_put_att(ncid, var_id, 'LwSrc_meaning', 'j point index of RHO center source/sink') )  

      dim3Dids = (/ riv_dimid, zr_dimid, t_dimid /)

      do i=6, N_var

        if (name_flag( i ) == 0 ) cycle
        
        if( i==8  .or. i==9  .or. i==13 .or. i==14 .or. i==15 .or. i==16 .or.  &
            i==17 .or. i==21 .or. i==22 .or. i==23 .or. i==24 .or. i==26 .or.  &
            i==27 .or. i==28 .or. i==29 .or. i==30 .or. i==33 .or. i==34 .or.  &
            i==35 .or. i==36  ) then  ! mud_, sand_, etc...
          
          if( i==8 ) Ntype = NCS
          if( i==9 ) Ntype = NNS
          if( i==13 .or. i==21 .or. i==23 .or. i==26 .or. i==33  ) Ntype = Ndom
          if( i==14 .or. i==22 .or. i==24 .or. i==27 .or. i==34  ) Ntype = Npom
          if( i==15 .or. i==28 .or. i==35  ) Ntype = Nphy
          if( i==16 .or. i==29 .or. i==36  ) Ntype = Nzoo
          if( i==17  ) Ntype = Npim

          do j=1,Ntype
            write(varnum,'(I2.2)') j
            varname = 'river_'//trim( VAR_NAME2(i) )//varnum
            lvarname = 'river runoff '//trim( VAR_NAME2(i) )//varnum

            write(*,*) 'Add variable: ', trim( varname )
            call check( nf90_def_var(ncid, trim( varname ), NF90_DOUBLE, dim3Dids, var_id) )
            call check( nf90_put_att(ncid, var_id, 'long_name', trim( lvarname ) ) )
            call check( nf90_put_att(ncid, var_id, 'units', trim( VAR_UNIT(i) ) ) )
          enddo
        else
          varname = 'river_'//trim( VAR_NAME2(i) )
          lvarname = 'river runoff '//trim( VAR_NAME2(i) )

          write(*,*) 'Add variable: ', trim( varname  )       
          call check( nf90_def_var(ncid, trim( varname ), NF90_DOUBLE, dim3Dids, var_id) )
          call check( nf90_put_att(ncid, var_id, 'long_name', trim( lvarname ) ) )
          call check( nf90_put_att(ncid, var_id, 'units', trim( VAR_UNIT(i) ) ) )
        endif
      enddo

  ! End define mode.
      call check( nf90_enddef(ncid) )
      call check( nf90_close(ncid) )
      write(*,*) '*** SUCCESS'

    END SUBROUTINE createNetCDFriver

!**** writeNetCDF_1d **********************************************
      
    SUBROUTINE writeNetCDF_1d(   &
!        input parameters
            NCNAME                 &
          , OUT_FILE               &
          , Nxr                     &
          , data                   &
          , start1D, count1D       &
      )
                               
!    input parameters
      character(len=*), intent( in) :: NCNAME
      character(len=*), intent( in) :: OUT_FILE
      integer, intent( in) :: Nxr 
      real(8), intent( in) :: data(Nxr )
      integer, intent( in) :: start1D(1), count1D(1)
      
      integer :: ncid,var_id
      
! --- Write NetCDF file ------------------------
      
      write(*,*) "WRITE ", NCNAME," to ", trim( OUT_FILE )
      call check( nf90_open(OUT_FILE, NF90_WRITE, ncid) )
      call check( nf90_inq_varid(ncid, NCNAME, var_id) )
      call check( nf90_put_var(ncid, var_id, data, start = start1D, count = count1D) )
      call check( nf90_close(ncid) )
      write(*,*) '*** SUCCESS'

    END SUBROUTINE writeNetCDF_1d
      
!**** writeNetCDF_2d **********************************************
      
    SUBROUTINE writeNetCDF_2d(   &
!        input parameters
            NCNAME               &
          , OUT_FILE             &
          , Nxr, Nyr             &
          , data                 &
          , start2D, count2D     &
      )
                               
!    input parameters
      character(len=*), intent( in) :: NCNAME
      character(len=*), intent( in) :: OUT_FILE
      integer, intent( in) :: Nxr, Nyr
      real(8), intent( in) :: data(Nxr, Nyr)
      integer, intent( in) :: start2D(2), count2D(2)
      
      integer :: ncid,var_id
      
! --- Write NetCDF file ------------------------
      
      write(*,*) "WRITE ", NCNAME," to ", trim( OUT_FILE )
      call check( nf90_open(OUT_FILE, NF90_WRITE, ncid) )
      call check( nf90_inq_varid(ncid, NCNAME, var_id) )
      call check( nf90_put_var(ncid, var_id, data, start = start2D, count = count2D) )
      call check( nf90_close(ncid) )
      write(*,*) '*** SUCCESS'

    END SUBROUTINE writeNetCDF_2d
      
!**** writeNetCDF_3d **********************************************
      
    SUBROUTINE writeNetCDF_3d(   &
!        input parameters
            NCNAME               &
          , OUT_FILE             &
          , Nxr, Nyr, Nt         &
          , data                 &
          , start3D, count3D     &
      )
                               
!    input parameters
      character(len=*), intent( in) :: NCNAME
      character(len=*), intent( in) :: OUT_FILE
      integer, intent( in) :: Nxr, Nyr, Nt 
      real(8), intent( in) :: data(Nxr, Nyr, Nt )
      integer, intent( in) :: start3D(3), count3D(3)
      
      integer :: ncid,var_id
      
! --- Write NetCDF file ------------------------
      
      write(*,*) "WRITE ", NCNAME," to ", trim( OUT_FILE )
      call check( nf90_open(OUT_FILE, NF90_WRITE, ncid) )
      call check( nf90_inq_varid(ncid, NCNAME, var_id) )
      call check( nf90_put_var(ncid, var_id, data, start = start3D, count = count3D) )
      call check( nf90_close(ncid) )
      write(*,*) '*** SUCCESS'

    END SUBROUTINE writeNetCDF_3d
      
!**** writeNetCDF_4d **********************************************
      
    SUBROUTINE writeNetCDF_4d(   &
!        input parameters
            NCNAME               &
          , OUT_FILE             &
          , Nxr, Nyr, Nzr, Nt    &
          , data                 &
          , start4D, count4D     &
      )
                               
!    input parameters
      character(len=*), intent( in) :: NCNAME
      character(len=*), intent( in) :: OUT_FILE
      integer, intent( in) :: Nxr, Nyr, Nzr, Nt
      real(8), intent( in) :: data(Nxr, Nyr, Nzr, Nt)
      integer, intent( in) :: start4D(4), count4D(4)
      
      integer :: ncid,var_id
      
! --- Write NetCDF file ------------------------
      
      write(*,*) "WRITE ", NCNAME," to ", trim( OUT_FILE )
      call check( nf90_open(OUT_FILE, NF90_WRITE, ncid) )
      call check( nf90_inq_varid(ncid, NCNAME, var_id) )
      call check( nf90_put_var(ncid, var_id, data, start = start4D, count = count4D) )
      call check( nf90_close(ncid) )
      write(*,*) '*** SUCCESS'

    END SUBROUTINE writeNetCDF_4d
!**** readNetCDF_2d **********************************************
      
  SUBROUTINE readNetCDF_2d(    &
!      input parameters
          ncid                   &
        , NCNAME                 &
        , Im, Jm                 &
        , start, count           &
!      output parameters
        , data                   &
    )
                               
!    input parameters
    integer, intent( in) :: ncid
    character(len=*), intent( in) :: NCNAME
    integer, intent( in) :: Im, Jm
    integer, intent( in) :: start(2), count(2)
    real(8), intent(out) :: data(Im, Jm)
    
    integer, parameter :: Num_try = 30
    integer :: var_id
    integer :: err_flag, status
    integer :: itry
    real(8) :: sf, off
      
! --- Read NetCDF file ------------------------
      
    write(*,*) 'READ: ', NCNAME
    ! Get variable id
    do itry=1,Num_try
      status = nf90_inq_varid(ncid, NCNAME, var_id)
      write(*,*) trim(nf90_strerror(status))
      if (status == nf90_noerr) exit
      if (itry== Num_try) stop
      write(*,*) '*** FAILED 1: Retry!'
    end do        
    do itry=1,Num_try
      status = nf90_get_var(ncid, var_id, data, start=start, count=count)
      write(*,*) trim(nf90_strerror(status))
      if (status == nf90_noerr) exit
      if (itry== Num_try) stop
      write(*,*) '*** READ FAILED: Retry!'
    end do
#ifndef HYCOM_LOCAL        
    do itry=1,Num_try
      status = nf90_get_att(ncid, var_id, 'scale_factor', sf)
      write(*,*) trim(nf90_strerror(status))
      if (status == nf90_noerr) exit
      if (itry== Num_try) stop
      write(*,*) '*** FAILED 2: Retry!'
    end do          
    do itry=1,Num_try
      status = nf90_get_att(ncid, var_id, 'add_offset', off)
      write(*,*) trim(nf90_strerror(status))
      if (status == nf90_noerr) exit
      if (itry== Num_try) stop
      write(*,*) '*** FAILED 3: Retry!'
    end do          
      
    data = data*sf+off
#endif
    write(*,*) '*** SUCCESS'

  END SUBROUTINE readNetCDF_2d

!**** readNetCDF_1d **********************************************
      
    SUBROUTINE readNetCDF_1d(   &
!         input parameters
           ncid, NCNAME, Nxr    &
!         output parameters
           , data               &
       )
                               
!    input parameters
      integer, intent( in) :: ncid
      character(len=*), intent( in) :: NCNAME
      integer, intent( in) :: Nxr
      real(8), intent(out) :: data(Nxr)
      
      integer, parameter :: Num_try = 50
      integer :: var_id
      integer :: status
      integer :: itry
      
! --- Read NetCDF file ------------------------
      
      write(*,*) 'READ: ', NCNAME
      ! Get variable id
      do itry=1,Num_try
        status = nf90_inq_varid(ncid, NCNAME, var_id)
        write(*,*) trim(nf90_strerror(status))
        if (status == nf90_noerr) exit
        if (itry== Num_try) stop
        write(*,*) '*** FAILED 1: Retry!'
      end do        
      do itry=1,Num_try
        status = nf90_get_var(ncid, var_id, data)
        write(*,*) trim(nf90_strerror(status))
        if (status == nf90_noerr) exit
        if (itry== Num_try) stop
        write(*,*) '*** READ FAILED: Retry!'
      end do        
      write(*,*) '*** SUCCESS'

  END SUBROUTINE readNetCDF_1d

!**** NetCDF utility **********************************************
            
  SUBROUTINE try_nf_open(NC_FILE, nf90_open_mode, ncid)
    
    character(len=*),  intent( in) :: NC_FILE
    integer,           intent( in) :: nf90_open_mode
    integer,           intent(out) :: ncid

    integer, parameter :: Num_try = 30
    integer :: status
    integer :: itry
    
    do itry=1,Num_try
      status = nf90_open(NC_FILE, nf90_open_mode, ncid)
      write(*,*) trim(nf90_strerror(status))
      if (status == nf90_noerr) exit
      if (itry== Num_try) stop
      write(*,*) '*** OPEN FAILED: Retry!'
    end do
    
  END SUBROUTINE try_nf_open
    
! -------------------------------------------------------------------------
     
  SUBROUTINE get_dimension(ncid, name, dim)
    
    integer,           intent( in) :: ncid
    character(len=*),  intent( in) :: name
    integer,           intent(out) :: dim

    integer, parameter :: Num_try = 50
    integer :: dimid
    integer :: status
    integer :: itry
    
    do itry=1,Num_try
      status = nf90_inq_dimid(ncid, name, dimid)
      write(*,*) trim(nf90_strerror(status))
      if (status == nf90_noerr) exit
      if (itry== Num_try) stop 
    end do
    do itry=1,Num_try
      status = nf90_inquire_dimension(ncid, dimid, len=dim)
      write(*,*) trim(nf90_strerror(status))
      if (status == nf90_noerr) exit
      if (itry == Num_try) stop 
    end do
    
  END SUBROUTINE get_dimension
! -------------------------------------------------------------------------
  SUBROUTINE check(status)
    
    integer, intent(in) :: status
    
!    print *, trim(nf90_strerror(status))
    if (status /= nf90_noerr) then 
      write(*,*) trim(nf90_strerror(status))
      stop "Stopped"
    end if
    
  END SUBROUTINE check    
      
END MODULE mod_output_nc
      
! -------------------------------------------------------------------------
