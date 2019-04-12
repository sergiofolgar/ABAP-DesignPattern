*&---------------------------------------------------------------------*
*& Report ZSFM_R_DPS_PROXY
*&---------------------------------------------------------------------*
*& Autor: Sergio Folgar
*& Patrón de diseño: Proxy
*& Tipo de patrón: Estructural
*& https://en.wikipedia.org/wiki/Proxy_pattern
*&---------------------------------------------------------------------*
REPORT zsfm_r_dps_proxy.


*--------------------------------------------------------------------*
* Interfaz Imagen
*--------------------------------------------------------------------*
INTERFACE lif_image.
  METHODS: display_image.
ENDINTERFACE.


*--------------------------------------------------------------------*
* Imagen real
*--------------------------------------------------------------------*
CLASS lcl_real_image DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES: lif_image.
    METHODS: constructor IMPORTING iv_filename TYPE string.
  PRIVATE SECTION.
    DATA: gv_filename TYPE string.
    METHODS: load_image_from_disk.
ENDCLASS.

CLASS lcl_real_image IMPLEMENTATION.
  METHOD constructor.
    me->gv_filename = iv_filename.
    me->load_image_from_disk( ).
  ENDMETHOD.

  METHOD load_image_from_disk.
    WRITE:/ 'Loading ', me->gv_filename.
  ENDMETHOD.

  METHOD lif_image~display_image.
    WRITE:/ 'Displaying ', me->gv_filename.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Proxy Image
*--------------------------------------------------------------------*
CLASS lcl_proxy_image DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES: lif_image.
    METHODS: constructor IMPORTING iv_filename TYPE string.
  PRIVATE SECTION.
    DATA: go_image    TYPE REF TO lcl_real_image,
          gv_filename TYPE string.
ENDCLASS.

CLASS lcl_proxy_image IMPLEMENTATION.
  METHOD constructor.
    me->gv_filename = iv_filename.
  ENDMETHOD.

  METHOD lif_image~display_image.
    IF me->go_image IS INITIAL.
      CREATE OBJECT me->go_image
        EXPORTING
          iv_filename = me->gv_filename.
    ENDIF.
    me->go_image->lif_image~display_image( ).
  ENDMETHOD.
ENDCLASS.



START-OF-SELECTION.
  DATA: lo_image1 TYPE REF TO lif_image,
        lo_image2 TYPE REF TO lif_image.

  lo_image1 ?= NEW lcl_proxy_image( 'File1.jpg' ).
  lo_image2 ?= NEW lcl_proxy_image( 'File2.jpg' ).
  lo_image1->display_image( ). "Loading necessary
  lo_image1->display_image( ). "Loading unnecessary
  lo_image2->display_image( ). "Loading necessary
  lo_image2->display_image( ). "Loading unnecessary
