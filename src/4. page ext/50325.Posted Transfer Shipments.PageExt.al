pageextension 50325 pageextension50325 extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("Control 1102601007")
        {
            field("Source No."; Rec."Source No.")
            {
            }
            field("Vehicle Registration No."; "Vehicle Registration No.")
            {
            }
            field("Shipped By User"; Rec."Shipped By User")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 20".

        addafter("Action 21")
        {
            action("Veh.Shipment")
            {
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TransShptHeader.RESET;
                    TransShptHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(33020027, TRUE, TRUE, TransShptHeader);
                end;
            }
            action(GatePass)
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CreateGatePass
                end;
            }
        }
    }

    procedure CreateGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
        Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
        TransfershipLine: Record "5745";
        LineNo: Integer;
    begin
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.", Rec."No.");
        IF NOT GatepassHeader.FINDFIRST THEN BEGIN
            GatepassHeader.INIT;
            IF Rec."Document Profile" = Rec."Document Profile"::Service THEN
                GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle Service"
            ELSE
                IF Rec."Document Profile" = Rec."Document Profile"::"Spare Parts Trade" THEN
                    GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Spare Parts Trade"
                ELSE
                    IF Rec."Document Profile" = Rec."Document Profile"::"Vehicles Trade" THEN
                        GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle Trade"
                    ELSE
                        IF Rec."Document Profile" = Rec."Document Profile"::" " THEN
                            GatepassHeader."Document Type" := GatepassHeader."Document Type"::Admin;
            GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::"Transfer Order";
            GatepassHeader."External Document No." := Rec."No.";
            GatepassHeader."Transfer To" := Rec."Transfer-to Name";
            GatepassHeader."Transfer From" := Rec."Transfer-from Name";
            GatepassHeader."Vehicle Registration No." := "Vehicle Registration No.";
            GatepassHeader.VALIDATE("Issued Date", TODAY);
            GatepassHeader.Destination := 'OUT';
            GatepassHeader.INSERT(TRUE);
        END;


        TransfershipLine.RESET;
        TransfershipLine.SETRANGE("Document No.", GatepassHeader."External Document No.");
        IF TransfershipLine.FINDFIRST THEN
            REPEAT
                GatepassLine.RESET;
                //GatepassLine.SETRANGE("Document Type",TransfershipLine."Document Profile");
                GatepassLine.SETRANGE("Ext Document No.", Rec."No.");
                IF TransfershipLine."Document Profile" = TransfershipLine."Document Profile"::"Vehicles Trade" THEN
                    GatepassLine.SETRANGE("Item No.", TransfershipLine."Vehicle Serial No.")
                ELSE
                    GatepassLine.SETRANGE("Item No.", TransfershipLine."Item No.");
                IF NOT GatepassLine.FINDFIRST THEN BEGIN
                    LineNo := 0;
                    GatepassLine.RESET;
                    IF GatepassLine.FINDLAST THEN
                        LineNo := GatepassLine."Line No." + 1;
                    CLEAR(GatepassLine);
                    GatepassLine.INIT;
                    GatepassLine."Line No." := LineNo;
                    GatepassLine."Document Type" := GatepassLine."Document Type"::"Vehicle Service";
                    IF Rec."Document Profile" = Rec."Document Profile"::"Vehicles Trade" THEN BEGIN
                        GatepassLine."Item Type" := GatepassLine."Item Type"::Vehicle;
                        GatepassLine.VALIDATE("Item No.", TransfershipLine."Vehicle Serial No.");
                    END
                    ELSE BEGIN
                        GatepassLine."Item Type" := GatepassLine."Item Type"::Spares;
                        GatepassLine.VALIDATE("Item No.", TransfershipLine."Item No.");
                    END;
                    GatepassLine."Document No." := GatepassHeader."Document No";
                    GatepassLine."Ext Document No." := Rec."No.";
                    GatepassLine.Quantity := TransfershipLine.Quantity;
                    GatepassLine.INSERT(TRUE);
                END;
            UNTIL TransfershipLine.NEXT = 0;
        //end;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
    end;
}

