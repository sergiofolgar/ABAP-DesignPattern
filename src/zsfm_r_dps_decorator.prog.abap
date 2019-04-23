*&---------------------------------------------------------------------*
*& Report ZSFM_R_DPS_DECORATOR
*&---------------------------------------------------------------------*
*& Autor: Sergio Folgar
*& Patrón de diseño: Decorator
*& Tipo de patrón: Estructural
*& https://en.wikipedia.org/wiki/Decorator_pattern
*&---------------------------------------------------------------------*
REPORT zsfm_r_dps_decorator.


*--------------------------------------------------------------------*
* Interfaz Cafe
*--------------------------------------------------------------------*
INTERFACE lif_coffee.
  METHODS: get_cost RETURNING VALUE(rv_cost) TYPE dmbtr,
    get_ingredients RETURNING VALUE(rv_ingr) TYPE string.
ENDINTERFACE.


*--------------------------------------------------------------------*
* Simple café sin ingredientes extras
*--------------------------------------------------------------------*
CLASS lcl_simple_coffee DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES: lif_coffee.
ENDCLASS.

CLASS lcl_simple_coffee IMPLEMENTATION.
  METHOD lif_coffee~get_cost.
    rv_cost = 1.
  ENDMETHOD.

  METHOD lif_coffee~get_ingredients.
    rv_ingr = 'Coffee'.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Las siguientes clases contienen los decoradores para todas las
* clases de café, incluidas las propias clases de decoradores.
*--------------------------------------------------------------------*
CLASS lcl_coffee_decorator DEFINITION ABSTRACT.
  PUBLIC SECTION.
    INTERFACES: lif_coffee.
    METHODS: constructor IMPORTING io_caffe TYPE REF TO lif_coffee.

  PRIVATE SECTION.
    DATA: go_coffee TYPE REF TO lif_coffee.

ENDCLASS.

CLASS lcl_coffee_decorator IMPLEMENTATION.
  METHOD constructor.
    me->go_coffee = io_caffe.
  ENDMETHOD.

  METHOD lif_coffee~get_cost.
    rv_cost = me->go_coffee->get_cost( ).
  ENDMETHOD.

  METHOD lif_coffee~get_ingredients.
    rv_ingr = me->go_coffee->get_ingredients( ).
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Decorador con leche
*--------------------------------------------------------------------*
CLASS lcl_with_milk DEFINITION INHERITING FROM lcl_coffee_decorator.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING io_caffe TYPE REF TO lif_coffee,
      lif_coffee~get_cost REDEFINITION,
      lif_coffee~get_ingredients REDEFINITION.
ENDCLASS.

CLASS lcl_with_milk IMPLEMENTATION.
  METHOD constructor.
    super->constructor( io_caffe ).
  ENDMETHOD.

  METHOD lif_coffee~get_cost.
    rv_cost = super->lif_coffee~get_cost( ) + '0.5'.
  ENDMETHOD.

  METHOD lif_coffee~get_ingredients.
    rv_ingr = super->lif_coffee~get_ingredients( ) &&  ', Milk'.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Decorador con hielo
*--------------------------------------------------------------------*
CLASS lcl_with_ice DEFINITION INHERITING FROM lcl_coffee_decorator.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING io_caffe TYPE REF TO lif_coffee,
      lif_coffee~get_cost REDEFINITION,
      lif_coffee~get_ingredients REDEFINITION.
ENDCLASS.

CLASS lcl_with_ice IMPLEMENTATION.
  METHOD constructor.
    super->constructor( io_caffe ).
  ENDMETHOD.

  METHOD lif_coffee~get_cost.
    rv_cost = super->lif_coffee~get_cost( ) + '0.25'.
  ENDMETHOD.

  METHOD lif_coffee~get_ingredients.
    rv_ingr = super->lif_coffee~get_ingredients( ) &&  ', Ice'.
  ENDMETHOD.
ENDCLASS.



START-OF-SELECTION.
  DATA: lo_coffee TYPE REF TO lif_coffee.

  lo_coffee ?= NEW lcl_simple_coffee( ).
  WRITE:/ 'Cost: ', lo_coffee->get_cost( ), 'Ingredients:', lo_coffee->get_ingredients( ).

  lo_coffee ?= NEW lcl_with_milk( lo_coffee ).
  WRITE:/ 'Cost: ', lo_coffee->get_cost( ), 'Ingredients:', lo_coffee->get_ingredients( ).

  lo_coffee ?= NEW lcl_with_ice( lo_coffee ).
  WRITE:/ 'Cost: ', lo_coffee->get_cost( ), 'Ingredients:', lo_coffee->get_ingredients( ).
*Output
*Cost:             1,00  Ingredients: Coffee
*Cost:             1,50  Ingredients: Coffee, Milk
*Cost:             1,75  Ingredients: Coffee, Milk, Ice
