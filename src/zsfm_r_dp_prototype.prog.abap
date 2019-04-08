*&---------------------------------------------------------------------*
*& Report ZSFM_R_DP_PROTOTYPE
*&---------------------------------------------------------------------*
*& Patrón de diseño: Prototype
*& Tipo de patrón: Creacional
*& https://en.wikipedia.org/wiki/Prototype_pattern
*&---------------------------------------------------------------------*
REPORT zsfm_r_dp_prototype.


CLASS lcl_parent DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: clone ABSTRACT RETURNING VALUE(ro_object) TYPE REF TO lcl_parent,
      set_date IMPORTING iv_date TYPE sydatum,
      get_date RETURNING VALUE(rv_date) TYPE sydatum.

  PRIVATE SECTION.
    DATA: gv_date TYPE sydatum.
ENDCLASS.


CLASS lcl_parent IMPLEMENTATION.

  METHOD set_date.
    me->gv_date = iv_date.
  ENDMETHOD.

  METHOD get_date.
    rv_date = me->gv_date.
  ENDMETHOD.

ENDCLASS.



CLASS lcl_child DEFINITION INHERITING FROM lcl_parent.
  PUBLIC SECTION.
    METHODS: clone REDEFINITION.
ENDCLASS.


CLASS lcl_child IMPLEMENTATION.

*--------------------------------------------------------------------*
* Lógica de clonado del objeto
*--------------------------------------------------------------------*
  METHOD clone.
    CREATE OBJECT ro_object TYPE lcl_child.
    ro_object->set_date( me->get_date( ) ).
  ENDMETHOD.

ENDCLASS.



START-OF-SELECTION.
  DATA: lo_obj1       TYPE REF TO lcl_parent,
        lo_obj1_clone TYPE REF TO lcl_parent,
        lo_obj2       TYPE REF TO lcl_parent,
        lo_obj2_clone TYPE REF TO lcl_parent.

  CREATE OBJECT lo_obj1 TYPE lcl_child.
  lo_obj1->set_date( '20190101' ).
  lo_obj1_clone = lo_obj1->clone( ).
  WRITE:/ '· Instancia 1: ', lo_obj1->get_date( ).
  WRITE:/ '· Instancia 1 - clone: ', lo_obj1_clone->get_date( ).

  CREATE OBJECT lo_obj2 TYPE lcl_child.
  lo_obj2->set_date( '20190102' ).
  lo_obj2_clone = lo_obj2->clone( ).
  WRITE:/ '· Instancia 2: ', lo_obj2->get_date( ).
  WRITE:/ '· Instancia 2 - clone: ', lo_obj2_clone->get_date( ).
