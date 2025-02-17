pageextension 50194 pageextension50194 extends "Available - Purchase Lines"
{
    // 11.07.2013 EDMS P8
    //   * Added code for "Service Line EDMS"

    var
        ServiceLineEDMS: Record "25006146";
        ReserveServiceLineEDMS: Codeunit "25006121";

    procedure SetServiceLineEDMS(var CurrentServLine: Record "25006146"; CurrentReservEntry: Record "337")
    begin
        CurrentServLine.TESTFIELD(Rec.Type, CurrentServLine.Type::Item);
        ServiceLineEDMS := CurrentServLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetServLineEDMS(ServiceLineEDMS);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveServiceLineEDMS.FilterReservFor(ReservEntry, ServiceLineEDMS);
        CaptionText := ReserveServiceLineEDMS.Caption(ServiceLineEDMS);
    end;
}

