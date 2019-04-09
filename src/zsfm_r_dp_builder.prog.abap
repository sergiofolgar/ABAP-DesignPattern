*&---------------------------------------------------------------------*
*& Report ZSFM_R_DP_SINGLETON
*&---------------------------------------------------------------------*
*& Autor: Sergio Folgar
*& Patrón de diseño: Builder
*& Tipo de patrón: Creacional
*& https://en.wikipedia.org/wiki/Builder_pattern
*&---------------------------------------------------------------------*
REPORT zsfm_r_dp_builder.


*--------------------------------------------------------------------*
* Producto (coche)
*--------------------------------------------------------------------*
CLASS lcl_car DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: set_color IMPORTING iv_color TYPE string,
      set_wheels IMPORTING iv_wheels TYPE i,
      get_color RETURNING VALUE(rv_color) TYPE string,
      get_wheels RETURNING VALUE(rv_wheels) TYPE i.

  PRIVATE SECTION.
    DATA: gv_wheels TYPE i,
          gv_color  TYPE string.
ENDCLASS.

CLASS lcl_car IMPLEMENTATION.
  METHOD get_color.
    rv_color = me->gv_color.
  ENDMETHOD.

  METHOD set_color.
    me->gv_color = iv_color.
  ENDMETHOD.

  METHOD get_wheels.
    rv_wheels = me->gv_wheels.
  ENDMETHOD.

  METHOD set_wheels.
    me->gv_wheels = iv_wheels.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Builder
*--------------------------------------------------------------------*
CLASS lcl_car_builder DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: constructor,
      get_car RETURNING VALUE(ro_car) TYPE REF TO lcl_car,
      set_color ABSTRACT,
      set_wheels ABSTRACT.

  PROTECTED SECTION.
    DATA: go_car TYPE REF TO lcl_car.
ENDCLASS.

CLASS lcl_car_builder IMPLEMENTATION.
  METHOD constructor.
    CREATE OBJECT me->go_car.
  ENDMETHOD.

  METHOD get_car.
    ro_car = me->go_car.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Coche = Ferrari
*--------------------------------------------------------------------*
CLASS lcl_ferrari_builder DEFINITION INHERITING FROM lcl_car_builder.
  PUBLIC SECTION.
    METHODS: set_color REDEFINITION,
      set_wheels REDEFINITION.
ENDCLASS.

CLASS lcl_ferrari_builder IMPLEMENTATION.
  METHOD set_color.
    me->go_car->set_color( 'Red' ).
  ENDMETHOD.

  METHOD set_wheels.
    me->go_car->set_wheels( 4 ).
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Coche = Camión
*--------------------------------------------------------------------*
CLASS lcl_truck_builder DEFINITION INHERITING FROM lcl_car_builder.
  PUBLIC SECTION.
    METHODS: set_color REDEFINITION,
      set_wheels REDEFINITION.
ENDCLASS.

CLASS lcl_truck_builder IMPLEMENTATION.
  METHOD set_color.
    me->go_car->set_color( 'While' ).
  ENDMETHOD.

  METHOD set_wheels.
    me->go_car->set_wheels( 8 ).
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Director
*--------------------------------------------------------------------*
CLASS lcl_director DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING io_car_builder TYPE REF TO lcl_car_builder,
      build RETURNING VALUE(ro_car) TYPE REF TO lcl_car.
  PRIVATE SECTION.
    DATA: go_car_builder TYPE REF TO lcl_car_builder.
ENDCLASS.

CLASS lcl_director IMPLEMENTATION.
  METHOD constructor.
    me->go_car_builder = io_car_builder.
  ENDMETHOD.

  METHOD build.
    me->go_car_builder->set_color( ).
    me->go_car_builder->set_wheels( ).
    ro_car = me->go_car_builder->get_car( ).
  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.
  DATA: lo_ferrari_builder TYPE REF TO lcl_car_builder,
        lo_truck_builder   TYPE REF TO lcl_car_builder,
        lo_director        TYPE REF TO lcl_director.

* Construir un ferrari
  CREATE OBJECT lo_ferrari_builder TYPE lcl_ferrari_builder.
  CREATE OBJECT lo_director
    EXPORTING
      io_car_builder = lo_ferrari_builder.
  WRITE:/ 'Ferrari'.
  WRITE:/ 'Color: ', lo_director->build( )->get_color( ).
  WRITE:/ 'Weels: ', lo_director->build( )->get_wheels( ).


* Construir un camión
  CREATE OBJECT lo_truck_builder TYPE lcl_truck_builder.
  CREATE OBJECT lo_director
    EXPORTING
      io_car_builder = lo_truck_builder.
  WRITE:/ 'Camión'.
  WRITE:/ 'Color: ', lo_director->build( )->get_color( ).
  WRITE:/ 'Weels: ', lo_director->build( )->get_wheels( ).
