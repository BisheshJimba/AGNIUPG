pageextension 50191 pageextension50191 extends "Available - Sales Lines"
{
    // 11.07.2013 EDMS P8
    //   * Added code for "Service Line EDMS"

    var
        ServiceLineEDMS: Record "25006146";
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
    #4..43
          JobPlanningLine.FIND;
          SetJobPlanningLine(JobPlanningLine,ReservEntry);
        END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..46
      DATABASE::"Service Line EDMS":  //11.07.2013 EDMS P8
        BEGIN
          ServiceLineEDMS.FIND;
          SetServiceLineEDMS(ServiceLineEDMS,ReservEntry);
        END;
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateReservMgt(PROCEDURE 7)".

    //procedure UpdateReservMgt();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEAR(ReservMgt);
    CASE ReservEntry."Source Type" OF
      DATABASE::"Sales Line":
    #4..21
        ReservMgt.SetServLine(ServiceInvLine);
      DATABASE::"Job Planning Line":
        ReservMgt.SetJobPlanningLine(JobPlanningLine);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..24
      DATABASE::"Service Line EDMS":  //11.07.2013 EDMS P8
        ReservMgt.SetServLineEDMS(ServiceLineEDMS);
    END;
    */
    //end;

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

