@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking related details'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YI_CDS_SUSH_booking as select from ysush_booking
association to parent YI_CDS_SUSH_TRAVEL as _Travel 
 on $projection.TravelUuid = _Travel.TravelUuid
{
    key booking_uuid as BookingUuid,
    key _Travel.TravelId as TravelId,
    travel_uuid as TravelUuid,
    booking_id as BookingId,
    booking_date as BookingDate,
    customer_id as CustomerId,
    carrier_id as CarrierId,
    connection_id as ConnectionId,
    flight_date as FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    flight_price as FlightPrice,
    currency_code as CurrencyCode,
    created_by as CreatedBy,
    last_changed_by as LastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    _Travel
}
