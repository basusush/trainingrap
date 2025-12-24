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
       LOOP AT travel_read_import ASSIGNING FIELD-SYMBOL(<LFS_TRAVELUUID>).
         DATA(LV_TRAVELUUID) = <LFS_TRAVELUUID>-TravelUuid.
       ENDLOOP.
     endif.

     READ ENTITIES OF yi_cds_sush_travel
     ENTITY Travel
     ALL FIELDS WITH travel_read_import
     RESULT data(travel)
     ENTITY Travel BY \_Booking
     ALL FIELDS WITH VALUE #( ( %key-TravelUuid = LV_TRAVELUUID  ) )
     RESULT data(booking).

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

*     MODIFY ENTITIES OF yi_cds_sush_travel
*     ENTITY Booking
*     UPDATE FIELDS ( FlightPrice )
*     WITH VALUE #( For row IN booking (
*                      %tky = row-%tky
*                      FlightPrice =  ) )


     READ ENTITIES OF yi_cds_sush_travel
     ENTITY Travel
     FIELDS ( BeginDate EndDate )
     with VALUE #( FOR row in travel ( %tky = row-%tky ) )
     result DATA(test_result) .

     MODIFY ENTITIES OF yi_cds_sush_travel
     ENTITY Travel
     CREATE FIELDS ( TravelId Description )
     WITH VALUE #( ( %cid = 'sush_record1'
                       %data = VALUE #( TravelId = '216'
                                         Description = 'desc2' ) ) )
     MAPPED DATA(lt_create_data)
     FAILED data(lt_failed).
*     out->write( test_result  ).

     if lt_failed is initial.
      commit ENTITIES.
     else.
      ROLLBACK ENTITIES.
     ENDIF.


     out->write( lt_create_data  ).

  ENDMETHOD.
ENDCLASS.
