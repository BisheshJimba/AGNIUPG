tableextension 50157 tableextension50157 extends "Tracking Specification"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5401)".


        //Unsupported feature: Code Insertion (VariableCollection) on ""Lot No."(Field 5400).OnValidate".

        //trigger (Variable: ServiceLineEDMS)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""Lot No."(Field 5400).OnValidate".

        //trigger "(Field 5400)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "Lot No." <> xRec."Lot No." THEN BEGIN
          TESTFIELD("Quantity Handled (Base)",0);
          TESTFIELD("Appl.-from Item Entry",0);
          IF IsReclass THEN
            "New Lot No." := "Lot No.";
          WMSManagement.CheckItemTrackingChange(Rec,xRec);
          InitExpirationDate;
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        IF Rec."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
          TransferLine.SETRANGE("Document No.", Rec."Source ID");
          TransferLine.SETRANGE("Item No.", Rec."Item No.");
          IF TransferLine.FINDFIRST THEN BEGIN
              ServiceLineEDMS.SETRANGE("Document No.", TransferLine."Source No.");
              ServiceLineEDMS.SETRANGE("No.", TransferLine."Item No." );
              IF ServiceLineEDMS.FINDFIRST THEN BEGIN
                ItemLedgEntry.SETRANGE("Transfer Source No.", ServiceLineEDMS."Document No.");
                ItemLedgEntry.SETRANGE("Transfer Source Type", DATABASE::"Service Header EDMS");
                ItemLedgEntry.SETRANGE("Item No.", ServiceLineEDMS."No.");
                ItemLedgEntry.SETRANGE("Location Code", ServiceLineEDMS."Location Code");
                IF ItemLedgEntry.FINDFIRST THEN REPEAT
                  IF ItemLedgEntry."Lot No." <> '' THEN BEGIN
                    IF ItemLedgEntry."Lot No." <> Rec."Lot No." THEN
                      LotNoMatch := FALSE
                    ELSE BEGIN
                      LotNoMatch := TRUE;
                      BREAK;
                    END;
                  END;
                UNTIL ItemLedgEntry.NEXT = 0;
                IF NOT LotNoMatch THEN
                  ERROR('Lot no. %1 not found in service order.', Rec."Lot No.");
              END;
          END;
        END;

        #1..8
        */
        //end;
    }

    //Unsupported feature: Property Modification (Length) on "SetItemData(PROCEDURE 29).VariantCode(Parameter 1003)".


    var
        ServiceLineEDMS: Record "25006146";
        TransferLine: Record "5741";
        ReservationEntry: Record "337";
        LotNo: Text;
        ItemLedgEntry: Record "32";
        LotNoMatch: Boolean;
}

