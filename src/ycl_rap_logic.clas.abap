CLASS ycl_rap_logic DEFINITION
  PUBLIC
  FINAL
*  INHERITING FROM cl_abap_behavior_handler.

  CREATE PUBLIC .

  PUBLIC SECTION.


  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_rap_logic IMPLEMENTATION.


   METHOD if_oo_adt_classrun~main.

     data:travel_read_import type TABLE FOR READ IMPORT yi_cds_sush_travel.
     select from yi_cds_sush_travel
     fields TravelUuid where TravelId = '0000025'
     into TABLE @DATA(Travel_keys).

     if Travel_keys is not INITIAL.
       travel_read_import = CORRESPONDING #( Travel_keys ).
     endif.

     READ ENTITIES OF yi_cds_sush_travel
     ENTITY Travel
     ALL FIELDS WITH travel_read_import
     RESULT data(travel).

     data: lv_begin type d,
           lv_enddate type d.

     lv_begin = cl_abap_context_info=>get_system_date( ).
     lv_enddate = lv_begin + 10.

     MODIFY ENTITIES OF yi_cds_sush_travel
     ENTITY Travel
     update FIELDS ( BeginDate EndDate )
     WITH VALUE #( FOR row IN travel (
                      %tky = row-%tky
                      BeginDate = lv_begin
                      EndDate = lv_enddate ) )

     FAILED data(failed_data)
     REPORTED data(reported_data).

     READ ENTITIES OF yi_cds_sush_travel
     ENTITY Travel
     FIELDS ( BeginDate EndDate )
     with VALUE #( FOR row in travel ( %tky = row-%tky ) )
     result DATA(test_result) .

     out->write( test_result  ).

  ENDMETHOD.
ENDCLASS.
