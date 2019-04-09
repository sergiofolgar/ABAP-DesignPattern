*&---------------------------------------------------------------------*
*& Report ZSFM_R_DPS_ADAPTER
*&---------------------------------------------------------------------*
*& Autor: Sergio Folgar
*& Patrón de diseño: Adapter
*& Tipo de patrón: Estructural
*& https://en.wikipedia.org/wiki/Adapter_pattern
*&---------------------------------------------------------------------*
REPORT zsfm_r_dps_adapter.


*--------------------------------------------------------------------*
* Guitarra
*--------------------------------------------------------------------*
CLASS lcl_guitar DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: on_guitar ABSTRACT,
      off_guitar ABSTRACT.
ENDCLASS.


*--------------------------------------------------------------------*
* Guitarra electrica
*--------------------------------------------------------------------*
CLASS lcl_electric_guitar DEFINITION INHERITING FROM lcl_guitar.
  PUBLIC SECTION.
    METHODS: on_guitar REDEFINITION,
      off_guitar REDEFINITION.
ENDCLASS.

CLASS lcl_electric_guitar IMPLEMENTATION.
  METHOD on_guitar.
    WRITE:/ 'Playing Guitar'.
  ENDMETHOD.

  METHOD off_guitar.
    WRITE:/ 'I am tired to play the guitar'.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Guitarra española
*--------------------------------------------------------------------*
CLASS lcl_spanish_guitar DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: play,
      leave_guitar.
ENDCLASS.

CLASS lcl_spanish_guitar IMPLEMENTATION.
  METHOD play.
    WRITE:/ 'Playing Guitar'.
  ENDMETHOD.

  METHOD leave_guitar.
    WRITE:/ 'I am tired to play the guitar'.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Adaptador de la guitarra española para que adaptarla al modelo LCL_GUITAR
*--------------------------------------------------------------------*
CLASS lcl_adapt_spanish_guitar DEFINITION INHERITING FROM lcl_guitar.
  PUBLIC SECTION.
    METHODS: constructor,
      on_guitar REDEFINITION,
      off_guitar REDEFINITION.

  PRIVATE SECTION.
    DATA: go_spanish_guitar TYPE REF TO lcl_spanish_guitar.
ENDCLASS.

CLASS lcl_adapt_spanish_guitar IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    CREATE OBJECT me->go_spanish_guitar.
  ENDMETHOD.

  METHOD on_guitar.
    me->go_spanish_guitar->play( ).
  ENDMETHOD.

  METHOD off_guitar.
    me->go_spanish_guitar->leave_guitar( ).
  ENDMETHOD.

ENDCLASS.



START-OF-SELECTION.
  DATA: lo_guitar TYPE REF TO lcl_guitar.

  CREATE OBJECT lo_guitar TYPE lcl_electric_guitar.
  lo_guitar->on_guitar( ).
  lo_guitar->off_guitar( ).

  CREATE OBJECT lo_guitar TYPE lcl_adapt_spanish_guitar.
  lo_guitar->on_guitar( ).
  lo_guitar->off_guitar( ).
