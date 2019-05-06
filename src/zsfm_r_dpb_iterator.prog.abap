*&---------------------------------------------------------------------*
*& Report ZSFM_R_DPB_ITERATOR
*&---------------------------------------------------------------------*
*& Autor: Sergio Folgar
*& Patrón de diseño: Iterator
*& Tipo de patrón: Comportamiento
*& https://en.wikipedia.org/wiki/Iterator_pattern
*& http://zevolving.com/2012/01/abap-objects-design-patterns-iterator
*&---------------------------------------------------------------------*
REPORT zsfm_r_dpb_iterator.


INTERFACE lif_iterator DEFERRED.

*--------------------------------------------------------------------*
* Interfaz Collección
*--------------------------------------------------------------------*
INTERFACE lif_collection.
  METHODS: get_iterator RETURNING VALUE(ro_iterator) TYPE REF TO lif_iterator,
    add IMPORTING io_object TYPE REF TO object,
    remove IMPORTING io_object TYPE REF TO object,
    clear,
    size RETURNING VALUE(rv_size) TYPE i,
    is_empty RETURNING VALUE(rv_empty) TYPE abap_bool,
    get IMPORTING iv_index         TYPE i
        RETURNING VALUE(ro_object) TYPE REF TO object.
ENDINTERFACE.

*--------------------------------------------------------------------*
* Interfaz Iterador
*--------------------------------------------------------------------*
INTERFACE lif_iterator.
  METHODS: has_next RETURNING VALUE(rv_next) TYPE abap_bool,
    get_next RETURNING VALUE(ro_object) TYPE REF TO object,
    first RETURNING VALUE(ro_object) TYPE REF TO object.
  DATA: gv_current    TYPE syindex,
        go_collection TYPE REF TO lif_collection.
ENDINTERFACE.


*--------------------------------------------------------------------*
* Clase Iterador
*--------------------------------------------------------------------*
CLASS lcl_iterator DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_iterator.
    METHODS: constructor IMPORTING io_collection TYPE REF TO lif_collection.
    ALIASES: has_next FOR lif_iterator~has_next,
             get_next FOR lif_iterator~get_next,
             first FOR lif_iterator~first.
  PRIVATE SECTION.
    ALIASES: gv_current   FOR lif_iterator~gv_current,
             go_collection FOR lif_iterator~go_collection.
ENDCLASS.

CLASS lcl_iterator IMPLEMENTATION.
  METHOD constructor.
    me->go_collection = io_collection.
  ENDMETHOD.

  METHOD lif_iterator~first.
    me->gv_current = 1.
    ro_object = me->go_collection->get( me->gv_current ).
  ENDMETHOD.

  METHOD lif_iterator~get_next.
    me->gv_current = me->gv_current + 1.
    ro_object = me->go_collection->get( me->gv_current ).
  ENDMETHOD.

  METHOD lif_iterator~has_next.
    CHECK me->go_collection->get( me->gv_current + 1 ) IS BOUND.
    rv_next = abap_true.
  ENDMETHOD.

ENDCLASS.


*--------------------------------------------------------------------*
* Clase collección
*--------------------------------------------------------------------*
CLASS lcl_collection DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_collection.
    DATA: gt_objects TYPE STANDARD TABLE OF REF TO object.
    ALIASES: get_iterator   FOR lif_collection~get_iterator,
             add            FOR lif_collection~add,
             remove         FOR lif_collection~remove,
             clear          FOR lif_collection~clear,
             size           FOR lif_collection~size,
             is_empty       FOR lif_collection~is_empty,
             get            FOR lif_collection~get.
ENDCLASS.

CLASS lcl_collection IMPLEMENTATION.
  METHOD lif_collection~get_iterator.
    CREATE OBJECT ro_iterator TYPE lcl_iterator
      EXPORTING
        io_collection = me.
  ENDMETHOD.

  METHOD lif_collection~add.
    APPEND io_object TO me->gt_objects.
  ENDMETHOD.

  METHOD lif_collection~remove.
    DELETE me->gt_objects WHERE table_line EQ io_object.
  ENDMETHOD.

  METHOD lif_collection~clear.
    CLEAR me->gt_objects[].
  ENDMETHOD.

  METHOD lif_collection~size.
    rv_size = lines( me->gt_objects[] ).
  ENDMETHOD.

  METHOD lif_collection~is_empty.
    CHECK me->size( ) IS INITIAL.
    rv_empty = abap_true.
  ENDMETHOD.

  METHOD lif_collection~get.
    READ TABLE me->gt_objects INTO ro_object INDEX iv_index.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Clase item
*--------------------------------------------------------------------*
CLASS lcl_item DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING iv_name TYPE string,
      get_name RETURNING VALUE(rv_name) TYPE string.
  PRIVATE SECTION.
    DATA: gv_name TYPE string.
ENDCLASS.

CLASS lcl_item IMPLEMENTATION.
  METHOD constructor.
    me->gv_name = iv_name.
  ENDMETHOD.

  METHOD get_name.
    rv_name = me->gv_name.
  ENDMETHOD.
ENDCLASS.


*--------------------------------------------------------------------*
* Clase principal
*--------------------------------------------------------------------*
CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: run.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD run.
    DATA(lo_collection) = NEW lcl_collection( ).
    DATA(lo_iterator) = lo_collection->get_iterator( ).

    DO 10 TIMES.
      lo_collection->add( NEW lcl_item( 'Name' && sy-index ) ).
    ENDDO.

    WHILE lo_iterator->has_next( ) = abap_true.
      WRITE:/ CAST lcl_item( lo_iterator->get_next( ) )->get_name( ).
    ENDWHILE.

  ENDMETHOD.
ENDCLASS.



START-OF-SELECTION.
  lcl_main=>run( ).
