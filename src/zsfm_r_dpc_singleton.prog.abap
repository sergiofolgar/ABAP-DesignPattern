*&---------------------------------------------------------------------*
*& Report ZSFM_R_DPC_SINGLETON
*&---------------------------------------------------------------------*
*& Autor: Sergio Folgar
*& Patrón de diseño: Singleton
*& Tipo de patrón: Creacional
*& https://en.wikipedia.org/wiki/Singleton_pattern
*&---------------------------------------------------------------------*
REPORT zsfm_r_dpc_singleton.


*--------------------------------------------------------------------*
* La clase LCL_APP se define como privada para evitar que se pueda
* instanciar
*--------------------------------------------------------------------*
CLASS lcl_app DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS: get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_app.
    METHODS: set_date IMPORTING iv_date TYPE sydatum,
      get_date RETURNING VALUE(rv_date) TYPE sydatum.

  PRIVATE SECTION.
    CLASS-DATA: go_app TYPE REF TO lcl_app.
    DATA: gv_date TYPE sydatum.
ENDCLASS.

CLASS lcl_app IMPLEMENTATION.
  METHOD get_instance.
    IF go_app IS INITIAL. CREATE OBJECT go_app. ENDIF.
    ro_instance = go_app.
  ENDMETHOD.

  METHOD set_date.
    me->gv_date = iv_date.
  ENDMETHOD.

  METHOD get_date.
    rv_date = me->gv_date.
  ENDMETHOD.
ENDCLASS.



START-OF-SELECTION.
  DATA(lo_app1) = lcl_app=>get_instance( ).
  lo_app1->set_date( '20190101' ).
  WRITE:/ '· Instancia 1: ', lo_app1->get_date( ).

  DATA(lo_app2) = lcl_app=>get_instance( ).
  WRITE:/ '· Instancia 2: ', lo_app2->get_date( ).
