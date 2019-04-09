*&---------------------------------------------------------------------*
*& Report ZSFM_R_DP_FACTORY
*&---------------------------------------------------------------------*
*& Patrón de diseño: Factory
*& Tipo de patrón: Creacional
*& https://en.wikipedia.org/wiki/Factory_(object-oriented_programming)
*&---------------------------------------------------------------------*
REPORT zsfm_r_dp_factory.


CLASS lcl_bill DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: get_tax_amount ABSTRACT RETURNING VALUE(rv_tax_amount) TYPE dmbtr,
      get_amount RETURNING VALUE(rv_amount) TYPE dmbtr,
      set_amount IMPORTING iv_amount TYPE dmbtr.
  PRIVATE SECTION.
    DATA: gv_amount TYPE dmbtr.
ENDCLASS.

CLASS lcl_bill IMPLEMENTATION.
  METHOD set_amount.
    me->gv_amount = iv_amount.
  ENDMETHOD.

  METHOD get_amount.
    rv_amount = me->gv_amount.
  ENDMETHOD.
ENDCLASS.



CLASS lcl_bill_type1 DEFINITION INHERITING FROM lcl_bill.
  PUBLIC SECTION.
    METHODS: get_tax_amount REDEFINITION.
ENDCLASS.

CLASS lcl_bill_type1 IMPLEMENTATION.
*--------------------------------------------------------------------*
* 21%
*--------------------------------------------------------------------*
  METHOD get_tax_amount.
    rv_tax_amount = me->get_amount( ) * ( 21 / 100 ).
  ENDMETHOD.
ENDCLASS.



CLASS lcl_bill_type2 DEFINITION INHERITING FROM lcl_bill.
  PUBLIC SECTION.
    METHODS: get_tax_amount REDEFINITION.
ENDCLASS.

CLASS lcl_bill_type2 IMPLEMENTATION.
*--------------------------------------------------------------------*
* 10%
*--------------------------------------------------------------------*
  METHOD get_tax_amount.
    rv_tax_amount = me->get_amount( ) * ( 10 / 100 ).
  ENDMETHOD.
ENDCLASS.



CLASS lcl_factory DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS: get_bill IMPORTING iv_type        TYPE char1
                            RETURNING VALUE(ro_bill) TYPE REF TO lcl_bill.
ENDCLASS.

CLASS lcl_factory IMPLEMENTATION.
*--------------------------------------------------------------------*
* Devuelve el objeto factura
*--------------------------------------------------------------------*
  METHOD get_bill.
    IF iv_type = '1'.
      CREATE OBJECT ro_bill TYPE lcl_bill_type1.
    ELSE.
      CREATE OBJECT ro_bill TYPE lcl_bill_type2.
    ENDIF.
  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.
  DATA: lo_bill_t1 TYPE REF TO lcl_bill,
        lo_bill_t2 TYPE REF TO lcl_bill.

  lo_bill_t1 = lcl_factory=>get_bill( '1' ).
  lo_bill_t1->set_amount( 100 ).

  lo_bill_t2 = lcl_factory=>get_bill( '2' ).
  lo_bill_t2->set_amount( 100 ).

  WRITE:/ 'Type 1: ', lo_bill_t1->get_tax_amount( ).
  WRITE:/ 'Type 2: ', lo_bill_t2->get_tax_amount( ).
