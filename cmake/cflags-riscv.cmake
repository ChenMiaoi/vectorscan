CHECK_INCLUDE_FILE_CXX("riscv_vector.h" HAVE_RISCV_VECTOR_H)

if(HAVE_RISCV_VECTOR_H)
    set(RVV_INTRIN_INC_H "riscv_vector.h")
    message(STATUS "Found riscv_vector.h")
else()
    message(WARNING "riscv_vector.h not found - RISC-V Vector extension may be unavailable")
    set(HAVE_RVV FALSE)
    set(HAVE_RVV_1_0 FALSE)
endif()

if(HAVE_RISCV_VECTOR_H)
    CHECK_C_SOURCE_COMPILES("
    #include <${RVV_INTRIN_INC_H}>

    int main() {
        size_t vl = vsetvl_e32m1(4);
        vfloat32m1_t a = vfmv_v_f_f32m1(1.0f, vl);
        vfloat32m1_t b = vfadd_vv_f32m1(a, a, vl);
        (void)b;
        return 0;
    }" HAVE_RVV)

    if(HAVE_RVV)
        message(STATUS "RISC-V Vector (RVV) extension support detected")
    else()
        message(WARNING "RISC-V Vector (RVV) extension not supported by compiler")
    endif()

    CHECK_C_SOURCE_COMPILES("
    #include <${RVV_INTRIN_INC_H}>

    #if __riscv_v != 10000
    #error \"RVV version mismatch\"
    #endif

    int main() { return 0; }" HAVE_RVV_1_0)

    if(NOT HAVE_RVV_1_0)
        message(WARNING "RVV version is not 1.0 (or version check failed)")
    else()
        message(STATUS "RVV version 1.0 confirmed")
    endif()
endif()
