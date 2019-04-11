*&---------------------------------------------------------------------*
*& Report ZSFM_R_DPS_FACADE
*&---------------------------------------------------------------------*
*& Autor: Sergio Folgar
*& Patrón de diseño: Facade
*& Tipo de patrón: Estructural
*& https://en.wikipedia.org/wiki/Facade_pattern
*&---------------------------------------------------------------------*
REPORT zsfm_r_dps_facade.


*--------------------------------------------------------------------*
* Subsistema A
*--------------------------------------------------------------------*
CLASS lcl_subsystem_a DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: operation_1,
      operation_2.
ENDCLASS.

CLASS lcl_subsystem_a IMPLEMENTATION.
  METHOD operation_1.
    WRITE:/ 'Subsystem A - Operation 1'.
  ENDMETHOD.

  METHOD operation_2.
    WRITE:/ 'Subsystem A - Operation 2'.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Subsistema B
*--------------------------------------------------------------------*
CLASS lcl_subsystem_b DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: operation_1,
      operation_2.
ENDCLASS.

CLASS lcl_subsystem_b IMPLEMENTATION.
  METHOD operation_1.
    WRITE:/ 'Subsystem B - Operation 1'.
  ENDMETHOD.

  METHOD operation_2.
    WRITE:/ 'Subsystem B - Operation 2'.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Subsistema C
*--------------------------------------------------------------------*
CLASS lcl_subsystem_c DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: operation_1,
      operation_2.
ENDCLASS.

CLASS lcl_subsystem_c IMPLEMENTATION.
  METHOD operation_1.
    WRITE:/ 'Subsystem C - Operation 1'.
  ENDMETHOD.

  METHOD operation_2.
    WRITE:/ 'Subsystem C - Operation 2'.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Facade
*--------------------------------------------------------------------*
CLASS lcl_facade DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: operation_1,
      operation_2.
ENDCLASS.

CLASS lcl_facade IMPLEMENTATION.
  METHOD operation_1.
    NEW lcl_subsystem_a( )->operation_1( ).
    NEW lcl_subsystem_b( )->operation_1( ).
    NEW lcl_subsystem_c( )->operation_1( ).
  ENDMETHOD.

  METHOD operation_2.
    NEW lcl_subsystem_a( )->operation_2( ).
    NEW lcl_subsystem_b( )->operation_2( ).
    NEW lcl_subsystem_c( )->operation_2( ).
  ENDMETHOD.
ENDCLASS.



START-OF-SELECTION.
  DATA(lo_facade) = NEW lcl_facade( ).
  lo_facade->operation_1( ).
  lo_facade->operation_2( ).
