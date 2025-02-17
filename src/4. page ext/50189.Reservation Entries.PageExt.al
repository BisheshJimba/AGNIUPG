pageextension 50189 pageextension50189 extends "Reservation Entries"
{
    // 21.04.2014 Elva Baltic P1 #RX MMG7.00
    //   Modified CancelReservation - OnAction()
    // 
    // 31.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified function:
    //     LookupReserved
    actions
    {


        //Unsupported feature: Code Modification on "CancelReservation(Action 64).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(ReservEntry);
        IF ReservEntry.FIND('-') THEN
          REPEAT
            ReservEntry.TESTFIELD("Reservation Status","Reservation Status"::Reservation);
            ReservEntry.TESTFIELD("Disallow Cancellation",FALSE);
            IF CONFIRM(
                 Text001,FALSE,ReservEntry."Quantity (Base)",
                 ReservEntry."Item No.",ReservEngineMgt.CreateForText(Rec),
        #9..11
              COMMIT;
            END;
          UNTIL ReservEntry.NEXT = 0;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..5
            //21.04.2014 Elva Baltic P1 #RX MMG7.00 >>
            CLEAR(ServTransferMgt);
            IF ServTransferMgt.IsServiceLocation(ReservEntry."Location Code") THEN BEGIN
              UserSetup.RESET;
              UserSetup.GET(USERID);
              UserSetup.TESTFIELD("Allow Cancel Service Reserv.");
            END;
            //21.04.2014 Elva Baltic P1 #RX MMG7.00 <<
        #6..14
        */
        //end;
    }

    var
        UserSetup: Record "91";
        ServTransferMgt: Codeunit "25006010";

    //Unsupported feature: Variable Insertion (Variable: ServiceLineEDMS) (VariableCollection) on "LookupReserved(PROCEDURE 1)".



    //Unsupported feature: Code Modification on "LookupReserved(PROCEDURE 1)".

    //procedure LookupReserved();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH ReservEntry DO
      CASE "Source Type" OF
        DATABASE::"Sales Line":
    #4..99
            AssemblyLine.SETRANGE("Line No.","Source Ref. No.");
            PAGE.RUNMODAL(0,AssemblyLine);
          END;
      END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..102
        // 31.03.2014 Elva Baltic P21 #F182 MMG7.00 >>
        DATABASE::"Service Line EDMS":
          BEGIN
            ServiceLineEDMS.SETRANGE("Document Type","Source Subtype");
            ServiceLineEDMS.SETRANGE("Document No.","Source ID");
            ServiceLineEDMS.SETRANGE("Line No.","Source Ref. No.");
            PAGE.RUNMODAL(0,ServiceLineEDMS);
          END;
        // 31.03.2014 Elva Baltic P21 #F182 MMG7.00 <<
      END;
    */
    //end;
}

