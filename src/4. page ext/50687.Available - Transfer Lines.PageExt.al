pageextension 50687 pageextension50687 extends "Available - Transfer Lines"
{
    // 11.07.2013 EDMS P8
    //   * Added code for "Service Line EDMS"

    var
        ServSpecEDMS: Boolean;
        ServSpecDocType: Integer;
        ServSpecDocNo: Code[20];
        ServiceLineEDMS: Record "25006146";
        ReserveServiceLineEDMS: Codeunit "25006121";


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ReservEntry.TESTFIELD("Source Type");
    IF NOT DirectionIsSet THEN
      ERROR(Text000);
    #4..16
    SETRANGE("Item No.",ReservEntry."Item No.");
    SETRANGE("Variant Code",ReservEntry."Variant Code");
    SETFILTER("Outstanding Qty. (Base)",'>0');
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..19

    //11.07.2013 EDMS P8 >>
    IF ServSpecEDMS THEN BEGIN
      SETRANGE("Source Type",DATABASE::"Service Line EDMS");
      SETRANGE("Source Subtype",ServSpecDocType);
      SETRANGE("Source No.",ServSpecDocNo);
    END;
    //11.07.2013 EDMS P8 <<
    */
    //end;

    procedure SetServiceReserv(DocumentType: Integer; DocumentNo: Code[20])
    begin
        //EDMS function
        ServSpecEDMS := TRUE;
        ServSpecDocType := DocumentType;
        ServSpecDocNo := DocumentNo;
    end;

    procedure SetServiceLineEDMS(var CurrentServiceLine: Record "25006146"; CurrentReservEntry: Record "337")
    begin
        CurrentServiceLine.TESTFIELD(Type, CurrentServiceLine.Type::Item);
        ServiceLineEDMS := CurrentServiceLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetServLineEDMS(ServiceLineEDMS);
        ReservMgt.GetServiceReserv(ServSpecEDMS, ServSpecDocType, ServSpecDocNo);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveServiceLineEDMS.FilterReservFor(ReservEntry, ServiceLineEDMS);
        CaptionText := ReserveServiceLineEDMS.Caption(ServiceLineEDMS);
        SetInbound(ReservMgt.IsPositive());
    end;
}

