*&---------------------------------------------------------------------*
*& Report ZSFM_R_DPS_BRIDGE
*&---------------------------------------------------------------------*
*& Autor: Sergio Folgar
*& Patrón de diseño: Proxy
*& Tipo de patrón: Estructural
*& https://en.wikipedia.org/wiki/Bridge_pattern
*& https://www.tutorialspoint.com/design_pattern/bridge_pattern.htm
*&---------------------------------------------------------------------*
REPORT zsfm_r_dps_bridge.


*--------------------------------------------------------------------*
* Interfaz DrawAPI
*--------------------------------------------------------------------*
INTERFACE lif_draw_api.
  METHODS: draw_circle IMPORTING iv_radius TYPE i
                                 iv_x      TYPE i
                                 iv_y      TYPE i.
ENDINTERFACE.


*--------------------------------------------------------------------*
* Círculo Rojo
*--------------------------------------------------------------------*
CLASS lcl_red_circle DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES: lif_draw_api.
ENDCLASS.

CLASS lcl_red_circle IMPLEMENTATION.

  METHOD lif_draw_api~draw_circle.
    WRITE:/ 'Drawing Circle[ color: red, radius: ', iv_radius, ', x: ', iv_x, ', ', iv_y , ']'.
  ENDMETHOD.

ENDCLASS.


*--------------------------------------------------------------------*
* Círculo Verde
*--------------------------------------------------------------------*
CLASS lcl_green_circle DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES: lif_draw_api.
ENDCLASS.

CLASS lcl_green_circle IMPLEMENTATION.

  METHOD lif_draw_api~draw_circle.
    WRITE:/ 'Drawing Circle[ color: green, radius: ', iv_radius, ', x: ', iv_x, ', ', iv_y , ']'.
  ENDMETHOD.

ENDCLASS.


*--------------------------------------------------------------------*
* Clase abstracta Forma
*--------------------------------------------------------------------*
CLASS lcl_shape DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING io_draw TYPE REF TO lif_draw_api,
      draw ABSTRACT.

  PROTECTED SECTION.
    DATA: go_draw  TYPE REF TO lif_draw_api.
ENDCLASS.

CLASS lcl_shape IMPLEMENTATION.
  METHOD constructor.
    me->go_draw = io_draw.
  ENDMETHOD.

ENDCLASS.


*--------------------------------------------------------------------*
* Clase forma Círculo
*--------------------------------------------------------------------*
CLASS lcl_circle DEFINITION FINAL INHERITING FROM lcl_shape.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING iv_x      TYPE i
                                   iv_y      TYPE i
                                   iv_radius TYPE i
                                   io_draw   TYPE REF TO lif_draw_api,
      draw REDEFINITION.
  PRIVATE SECTION.
    DATA: gv_x      TYPE i,
          gv_y      TYPE i,
          gv_radius TYPE i.
ENDCLASS.

CLASS lcl_circle IMPLEMENTATION.

  METHOD constructor.
    super->constructor( io_draw ).
    me->gv_x = iv_x.
    me->gv_y = iv_y.
    me->gv_radius = iv_radius.
  ENDMETHOD.

  METHOD draw.
    me->go_draw->draw_circle( iv_radius = me->gv_radius
                              iv_x      = me->gv_x
                              iv_y      = me->gv_y ).
  ENDMETHOD.

ENDCLASS.



START-OF-SELECTION.
  DATA: lo_shape_red   TYPE REF TO lcl_shape,
        lo_shape_green TYPE REF TO lcl_shape.

  lo_shape_red ?= NEW lcl_circle( iv_x = 100 iv_y = 100 iv_radius = 10 io_draw = NEW lcl_red_circle( ) ).
  lo_shape_green ?= NEW lcl_circle( iv_x = 100 iv_y = 100 iv_radius = 10 io_draw = NEW lcl_green_circle( ) ).
  lo_shape_red->draw( ).
  lo_shape_green->draw( ).
