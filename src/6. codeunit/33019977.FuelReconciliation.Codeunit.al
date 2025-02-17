codeunit 33019977 "Fuel Reconciliation"
{

    trigger OnRun()
    begin
    end;

    var
        GlobalFuelLedgEntry: Record "33019965";
        GlobalFuelReconciliation: Record "33019980";
        GblUserSetup: Record "91";
        GlobalWindow: Dialog;
        Text33019961: Label 'Importing - #1#####################';
        Text33019962: Label 'Reconciling - #1#####################';

    [Scope('Internal')]
    procedure insertReconciliatonDetails(ParmFromDate: Date; ParmToDate: Date; ParmPetrolPump: Code[20]; ParmLocation: Code[10])
    var
        Text33019964: Label 'No records found with given filter(s) - Petrol Pump - %1, From Date (AD) - %2, To Date (AD) - %3 and Location - %4. All records during this period are reconciled.';
        Text33019965: Label 'Import successful!';
    begin
        //Getting reconciliation details from Fuel Ledger Entry and inserting into Fuel Reconciliaton.
        /*GblUserSetup.GET(USERID);
        
        GlobalFuelLedgEntry.RESET;
        GlobalFuelLedgEntry.SETCURRENTKEY(Location,"Petrol Pump","Posting Type",Reconciled,Void,"Posting Date");
        GlobalFuelLedgEntry.SETRANGE(Location,GblUserSetup."Default Location");
        GlobalFuelLedgEntry.SETRANGE("Petrol Pump",ParmPetrolPump);
        GlobalFuelLedgEntry.SETRANGE(Location,ParmLocation);
        GlobalFuelLedgEntry.SETFILTER("Posting Type",'Negative Adjmt.');
        GlobalFuelLedgEntry.SETRANGE(Reconciled,FALSE);
        GlobalFuelLedgEntry.SETRANGE(Void,FALSE);
        GlobalFuelLedgEntry.SETFILTER("Posting Date",'%1..%2',ParmFromDate,ParmToDate);
        IF GlobalFuelLedgEntry.FIND('-') THEN BEGIN
          GlobalWindow.OPEN(Text33019961);
          GlobalWindow.UPDATE(1,STRSUBSTNO(FORMAT(GlobalFuelLedgEntry."Entry No."),GlobalFuelLedgEntry."Petrol Pump"));
          REPEAT
            GlobalFuelReconciliation.INIT;
            GlobalFuelReconciliation."Entry No." := GlobalFuelLedgEntry."Entry No.";
            //GlobalFuelReconciliation."Document Type" := GlobalFuelLedgEntry."Document Type";
            GlobalFuelReconciliation."Document No." := GlobalFuelLedgEntry."Document No.";
            //GlobalFuelReconciliation."Issue Type" := GlobalFuelLedgEntry."Issue Type";
            //GlobalFuelReconciliation."Movement Type" := GlobalFuelLedgEntry."Movement Type";
            GlobalFuelReconciliation."Document No." := GlobalFuelLedgEntry.Description;
            //GlobalFuelReconciliation."Fuel Type" := GlobalFuelLedgEntry."Fuel Type";
            //GlobalFuelReconciliation."Petrol Pump" := GlobalFuelLedgEntry."Petrol Pump";
            GlobalFuelReconciliation."Issued Coupon No." := GlobalFuelLedgEntry."Issued Coupon No.";
            GlobalFuelReconciliation."Issued Date" := GlobalFuelLedgEntry."Issued Date";
            GlobalFuelReconciliation."Issued For" := GlobalFuelLedgEntry."Issued For";
            GlobalFuelReconciliation."File No." := GlobalFuelLedgEntry.Location;
            GlobalFuelReconciliation.Department := GlobalFuelLedgEntry.Department;
            GlobalFuelReconciliation."Staff No." := GlobalFuelLedgEntry."Staff No.";
            GlobalFuelReconciliation."Rack Location" := GlobalFuelLedgEntry.Amount;
            GlobalFuelReconciliation."Unit of Measure" := GlobalFuelLedgEntry."Unit of Measure";
            GlobalFuelReconciliation.Rate := GlobalFuelLedgEntry.Rate;
            GlobalFuelReconciliation.Quantity := GlobalFuelLedgEntry.Quantity;
            GlobalFuelReconciliation."Posting Date" := GlobalFuelLedgEntry."Posting Date";
            GlobalFuelReconciliation."Room No." := GlobalFuelLedgEntry."Document Date";
            GlobalFuelReconciliation."Rack No." := GlobalFuelLedgEntry."User ID";
            GlobalFuelReconciliation.INSERT;
          UNTIL GlobalFuelLedgEntry.NEXT = 0;
          GlobalWindow.CLOSE;
          MESSAGE(Text33019965);
        END ELSE
          MESSAGE(Text33019964,ParmPetrolPump,ParmFromDate,ParmToDate,GblUserSetup."Default Location");
         */

    end;

    [Scope('Internal')]
    procedure reconcileFuelLedger(ParmFuelReconciliation: Record "33019980")
    var
        LocalFuelLedgEntry: Record "33019965";
        Text33019963: Label '%1 entries reconciled and %2 entries not reconciled.';
        LocalNoReconciled: Integer;
        LocalNoNotReconciled: Integer;
        LclFuelRecon: Record "33019980";
    begin
        //Code to reconcile fuel ledger entry.
        /*WITH ParmFuelReconciliation DO BEGIN
          GlobalWindow.OPEN(Text33019962);
          GlobalWindow.UPDATE(1,STRSUBSTNO(FORMAT(ParmFuelReconciliation."Entry No."),ParmFuelReconciliation."Petrol Pump"));
          LclFuelRecon.RESET;
          LclFuelRecon.SETRANGE("File No.",ParmFuelReconciliation."File No.");
          IF LclFuelRecon.FIND('-') THEN BEGIN
            REPEAT
              IF LclFuelRecon."Sub Rack No." THEN BEGIN
                LocalFuelLedgEntry.RESET;
                LocalFuelLedgEntry.SETRANGE("Entry No.",LclFuelRecon."Entry No.");
                IF LocalFuelLedgEntry.FIND('-') THEN BEGIN
                  LocalFuelLedgEntry.Quantity := LclFuelRecon.Quantity;
                  LocalFuelLedgEntry.Rate := LclFuelRecon.Rate;
                  LocalFuelLedgEntry.Amount := LclFuelRecon."Rack Location";
                  LocalFuelLedgEntry.Reconciled := TRUE;
                  LocalFuelLedgEntry.MODIFY;
                END;
                LocalNoReconciled := LocalNoReconciled + 1;
              END ELSE
                LocalNoNotReconciled := LocalNoNotReconciled + 1;
            UNTIL LclFuelRecon.NEXT = 0;
          END;
          //Calling function to delete all current instance records.
          deleteAfterReconcile(ParmFuelReconciliation);
          GlobalWindow.CLOSE;
          MESSAGE(Text33019963,LocalNoReconciled,LocalNoNotReconciled);
        END;
        */

    end;

    [Scope('Internal')]
    procedure deleteAfterReconcile(ParmFuelReconciliation2: Record "33019980")
    var
        LocalFuelRecon2: Record "33019980";
    begin
        //Deleting records after reconciliation.
        /*WITH ParmFuelReconciliation2 DO BEGIN
          LocalFuelRecon2.RESET;
          LocalFuelRecon2.SETRANGE("Petrol Pump",ParmFuelReconciliation2."Petrol Pump");
          IF LocalFuelRecon2.FIND('-') THEN
            LocalFuelRecon2.DELETEALL;
        END;
         */

    end;
}

