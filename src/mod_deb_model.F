!!!=== Copyright (c) 2025 Takashi NAKAMURA  =====

!!!**** MODULE OF DYNAMIC ENRTGY BUDGET (DEB) MODEL **************************

MODULE mod_deb_model

  implicit none

CONTAINS

!  Temperature correction factor (no dimension)
!    Arrhenius equation
  real(8) function tempcorr1(T, Tref, T_A)
    real(8), intent(in) :: T     ! Temperature (K)
    real(8), intent(in) :: Tref  ! Refernce temperature (K)
    real(8), intent(in) :: T_A   ! Arrhenius temperature (K)

    tempcorr1 = exp(T_A*(1.0d0/Tref - 1.0d0/T))

  end function tempcorr1

!  Temperature correction factor (no dimension)
!    Arrhenius equation x enzyme denaturation at high and low temperatures
  real(8) function tempcorr2(T, Tref, T_A, T_H, T_AH, T_L, T_AL)
    real(8), intent(in) :: T     ! Temperature (K)
    real(8), intent(in) :: Tref  ! Refernce temperature (K)
    real(8), intent(in) :: T_A   ! Arrhenius temperature (K)
    real(8), intent(in) :: T_H   ! Upper boundary tolerance range (K)
    real(8), intent(in) :: T_AH  ! Arrhenius temp. for upper boundary (K)
    real(8), intent(in) :: T_L   ! Lower boundary tolerance range (K)
    real(8), intent(in) :: T_AL  ! Arrhenius temp. for lower boundary (K)

    tempcorr2 = exp(T_A*(1.0d0/Tref - 1.0d0/T))                  &
                * (1.0d0 + exp(T_AH*(1.0d0/T_H  - 1.0d0/Tref))   &
                         + exp(T_AL*(1.0d0/Tref - 1.0d0/T_L )) ) &
                / (1.0d0 + exp(T_AH*(1.0d0/T_H  - 1.0d0/T   ))   &
                         + exp(T_AL*(1.0d0/T    - 1.0d0/T_L )) )

  end function tempcorr2

! Somatic maintenance rate (J s-1)
  real(8) function somatic_maintenance(V, k_M)
    ! input parameters
    real(8), intent(in ) :: V     ! Body Volume (cm3)
    real(8), intent(in ) :: k_M   ! Somatic maintenance rate coefficient (J s-1 cm-3)

    somatic_maintenance = k_M * V  ! Somatic maintenance rate (J s-1)

  end function somatic_maintenance
  
!  Clearance rate (L s-1)
  subroutine clearance_rate(N, X, V, kT, C_Rmax, J_XiFmax, c2e, C_R, J_Rc)
    ! input parameters
    real(8), intent(in ) :: N           ! Number of food types
    real(8), intent(in ) :: X(N)        ! Food concentration (umol L-1)
    real(8), intent(in ) :: V           ! Body Volume (cm3)
    real(8), intent(in ) :: kT          ! Temperature correction factor (no dimension)
    real(8), intent(in ) :: C_Rmax      ! Maximum surface area specific clearance rate (L s-1 cm-2)
    real(8), intent(in ) :: J_XiFmax(N) ! Maximum surface area specific filtration rate (umol s−1 cm−2)
    real(8), intent(in ) :: c2e         ! enrtgy cost for water exchange (J L-1)
    ! output parameters
    real(8), intent(out) :: C_R         ! Clearance rate (L s-1)
    real(8), intent(out) :: J_Rc        ! Required energy for water exchange (J s-1)

    real(8) :: C_R   ! Clearance rate (L s-1)
    real(8) :: cff
    integer :: i

    cff = 0.0d0
    do i=1,N
      cff = cff + X(i)*C_Rmax/J_XiFmax(i)
    end do
    C_R = kT * C_Rmax * V**(2.0d0/3.0d0) / (1.0d0 + cff) ! Clearance rate (L s-1)

    J_Rc = C_R * c2e  ! Required enertgy for water exchange (J s-1)

  end subroutine clearance_rate

!  Filtration rate (umol s−1)
  subroutine filtration_rate(N, X, C_R, J_XiF)
    ! input parameters
    real(8), intent(in ) :: N           ! Number of food types
    real(8), intent(in ) :: X(N)        ! Food concentration (umol L-1)
    real(8), intent(in ) :: C_R         ! Clearance rate (L s-1)
    ! output parameters
    real(8), intent(out) :: J_XiF(N)    ! Filtration rate (umol s−1)

    real(8) :: C_R   ! Clearance rate (L s-1)
    real(8) :: cff
    integer :: i

    do i=1,N
      J_XiF(i) = C_R*X(i) ! Filtration rate (umol s−1)
    end do

  end subroutine filtration_rate

!  Ingestion rate (umol s−1)
  subroutine ingestion_rate(N, J_XiF, rho_XiI, J_XiImax, J_XiI)
    ! input parameters
    real(8), intent(in ) :: N           ! Number of food types
    real(8), intent(in ) :: J_XiF(N)    ! Filtration rate (umol s−1)
    real(8), intent(in ) :: rho_XiI(N)  ! Algal binding probability (no dim.)
    real(8), intent(in ) :: J_XiImax(N) ! Algal maximum ingestion rate (umol s−1)
    ! output parameters
    real(8), intent(out) :: J_XiI(N)    ! Ingestion rate (umol s−1)

    real(8) :: cff
    integer :: i

    cff = 0.0d0
    do i=1,N
      cff = cff + rho_XiI(i)*J_XiF(i) / J_XiImax(i)
    end do

    do i=1,N
      J_XiI(i) = rho_XiI(i)*J_XiF(i) / (1.0d0 + cff) ! Filtration rate (umol s−1)
    end do

  end subroutine ingestion_rate

!  Assimilation rate (umol s−1)
  subroutine assimilation_rate(N, J_XiI)
    ! input parameters
    real(8), intent(in ) :: N           ! Number of food types
    real(8), intent(in ) :: J_XiI(N)    ! Ingestion rate (umol s−1)
    real(8), intent(in ) :: J_XiF(N)    ! Filtration rate (umol s−1)
    real(8), intent(in ) :: rho_XiI(N)  ! Algal binding probability (no dim.)
    real(8), intent(in ) :: J_XiImax(N) ! Algal maximum ingestion rate (umol s−1)
    ! output parameters

    real(8) :: cff
    integer :: i

    cff = 0.0d0
    do i=1,N
      cff = cff + rho_XiI(i)*J_XiF(i) / J_XiImax(i)
    end do

    do i=1,N
      J_XiI(i) = rho_XiI(i)*J_XiF(i) / (1.0d0 + cff) ! Filtration rate (umol s−1)
    end do

  end subroutine assimilation_rate

END MODULE mod_deb_model



