pageextension 50195 pageextension50195 extends "Available - Item Ledg. Entries"
{
    // 11.07.2010 EDMS P8
    //   * Added code for "Service Line EDMS"

    var
        ServiceLineEdms: Record "25006146";

    var
        ReserveServiceLineEDMS: Codeunit "25006121";


    //Unsupported feature: Code Modification on "UpdateReservFrom(PROCEDURE 17)".

    //procedure UpdateReservFrom();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE ReservEntry."Source Type" OF
      DATABASE::"Sales Line":
        BEGIN
    #4..53
          AssemblyHeader.FIND;
          SetAssemblyHeader(AssemblyHeader,ReservEntry);
        END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..56
      DATABASE::"Service Line EDMS":  //11.07.2010 EDMS P8
        BEGIN
          ServiceLineEdms.FIND;
          SetServiceLineEDMS(ServiceLineEdms,ReservEntry);
        END;
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateReservMgt(PROCEDURE 13)".

    //procedure UpdateReservMgt();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEAR(ReservMgt);
    CASE ReservEntry."Source Type" OF
      DATABASE::"Sales Line":
    #4..21
        ReservMgt.SetAssemblyLine(AssemblyLine);
      DATABASE::"Assembly Header":
        ReservMgt.SetAssemblyHeader(AssemblyHeader);
    END;
    ReservMgt.SetSerialLotNo(ReservEntry."Serial No.",ReservEntry."Lot No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..24
      DATABASE::"Service Line EDMS":  //11.07.2010 EDMS P8
        ReservMgt.SetServLineEDMS(ServiceLineEdms);
    END;
    ReservMgt.SetSerialLotNo(ReservEntry."Serial No.",ReservEntry."Lot No.");
    */
    //end;

    procedure SetServiceLineEDMS(var CurrentServLine: Record "25006146"; CurrentReservEntry: Record "337")
    begin
        CurrentServLine.TESTFIELD(Type, CurrentServLine.Type::Item);
        ServiceLineEdms := CurrentServLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetServLineEDMS(ServiceLineEdms);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveSalesLine.FilterReservFor(ReservEntry, SalesLine);
        CaptionText := ReserveServiceLineEDMS.Caption(ServiceLineEdms);
    end;
}

