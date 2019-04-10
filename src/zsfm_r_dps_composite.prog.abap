*&---------------------------------------------------------------------*
*& Report ZSFM_R_DPS_ADAPTER
*&---------------------------------------------------------------------*
*& Autor: Sergio Folgar
*& Patrón de diseño: Composite
*& Tipo de patrón: Estructural
*& https://en.wikipedia.org/wiki/Composite_pattern
*&---------------------------------------------------------------------*
REPORT zsfm_r_dps_composite.


*--------------------------------------------------------------------*
* Interfaz Gráfico
*--------------------------------------------------------------------*
INTERFACE lif_graphic.
  METHODS: print.
ENDINTERFACE.


*--------------------------------------------------------------------*
* Composite Gráfico
*--------------------------------------------------------------------*
CLASS lcl_composite_graphic DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_graphic.
    METHODS: add_graphic IMPORTING io_graphic TYPE REF TO lif_graphic.

  PRIVATE SECTION.
    DATA: gt_graphics TYPE STANDARD TABLE OF REF TO lif_graphic.
ENDCLASS.

CLASS lcl_composite_graphic IMPLEMENTATION.
  METHOD add_graphic.
    APPEND io_graphic TO me->gt_graphics[].
  ENDMETHOD.

  METHOD lif_graphic~print.
    LOOP AT me->gt_graphics ASSIGNING FIELD-SYMBOL(<lwa_graphic>).
      <lwa_graphic>->print( ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Gráfico: Elipse
*--------------------------------------------------------------------*
CLASS lcl_ellipse DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_graphic.
ENDCLASS.

CLASS lcl_ellipse IMPLEMENTATION.
  METHOD lif_graphic~print.
    WRITE:/ 'Ellipse'.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Gráfico: Triángulo
*--------------------------------------------------------------------*
CLASS lcl_triangle DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_graphic.
ENDCLASS.

CLASS lcl_triangle IMPLEMENTATION.
  METHOD lif_graphic~print.
    WRITE:/ 'Triangle'.
  ENDMETHOD.
ENDCLASS.



START-OF-SELECTION.
  DATA(lo_composite) = NEW lcl_composite_graphic( ).
  DO 5 TIMES.
    lo_composite->add_graphic( NEW lcl_ellipse( ) ).
  ENDDO.
  DO 5 TIMES.
    lo_composite->add_graphic( NEW lcl_triangle( ) ).
  ENDDO.
  lo_composite->lif_graphic~print( ).
