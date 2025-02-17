page 33020058 "PDI List"
{
    CardPageID = "PDI Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33019851;
    SourceTableView = SORTING(No.);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Sales Date"; "Sales Date")
                {
                }
                field("PDI Date"; "PDI Date")
                {
                }
                field(Make; Make)
                {
                }
                field(Model; Model)
                {
                }
                field("Registration No."; "Registration No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field(Kilometrage; Kilometrage)
                {
                }
                field("Key No."; "Key No.")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Source ID"; "Source ID")
                {
                }
                field("Tyre F.L No."; "Tyre F.L No.")
                {
                }
                field("Tyre F.R No."; "Tyre F.R No.")
                {
                }
                field("Tyre R.L No."; "Tyre R.L No.")
                {
                }
                field("Tyre R.R. No."; "Tyre R.R. No.")
                {
                }
                field("Tyre F.L Size"; "Tyre F.L Size")
                {
                }
                field("Tyre F.R Size"; "Tyre F.R Size")
                {
                }
                field("Tyre R.L Size"; "Tyre R.L Size")
                {
                }
                field("Tyre R.R. Size"; "Tyre R.R. Size")
                {
                }
                field("Tyre F.L Make"; "Tyre F.L Make")
                {
                }
                field("Tyre F.R Make"; "Tyre F.R Make")
                {
                }
                field("Tyre R.L Make"; "Tyre R.L Make")
                {
                }
                field("Tyre R.R. Make"; "Tyre R.R. Make")
                {
                }
                field("Tyre Spare No."; "Tyre Spare No.")
                {
                }
                field("Tyre Spare Size"; "Tyre Spare Size")
                {
                }
                field("Tyre Spare Make"; "Tyre Spare Make")
                {
                }
                field("F.I Pump No."; "F.I Pump No.")
                {
                }
                field("F.I Pump Make"; "F.I Pump Make")
                {
                }
                field("Speedometer Make"; "Speedometer Make")
                {
                }
                field("Battery No."; "Battery No.")
                {
                }
                field("Battery Sr. No."; "Battery Sr. No.")
                {
                }
                field("Battery Make"; "Battery Make")
                {
                }
                field("Starter Motor Make"; "Starter Motor Make")
                {
                }
                field("Radiator Make"; "Radiator Make")
                {
                }
                field("Alternator Make"; "Alternator Make")
                {
                }
                field("S.L No."; "S.L No.")
                {
                }
                field("G.B No."; "G.B No.")
                {
                }
                field("F.A No."; "F.A No.")
                {
                }
                field("T.C No."; "T.C No.")
                {
                }
                field("R.A No."; "R.A No.")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1000000049>")
            {
                Caption = '&PDI Estimation';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PDIHdr);
                    REPORT.RUNMODAL(33020022, TRUE, FALSE, PDIHdr);
                end;
            }
            action("&Insurance Claim")
            {
                Caption = '&Insurance Claim';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PDIHdr);
                    REPORT.RUNMODAL(33020028, TRUE, FALSE, PDIHdr);
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

    var
        PDIHdr: Record "33019851";

    [Scope('Internal')]
    procedure CreateGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
        Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
        LineNo: Integer;
        PDILine: Record "33019852";
    begin
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.", "No.");
        IF NOT GatepassHeader.FINDFIRST THEN BEGIN
            GatepassHeader.INIT;
            GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle Service";
            GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::PDI;
            GatepassHeader."External Document No." := "No.";
            GatepassHeader."Vehicle Registration No." := Rec."Registration No.";
            //GatepassHeader."Ship Address" := "Ship-to Address";
            GatepassHeader.VALIDATE("Issued Date", TODAY);
            GatepassHeader.Destination := 'OUT';
            GatepassHeader.Kilometer := Kilometrage;
            GatepassHeader.INSERT(TRUE);
        END;

        PDILine.RESET;
        PDILine.SETRANGE("PDI No.", "No.");
        PDILine.SETFILTER("Repair Type", '<>%1', PDILine."Repair Type"::Labor);
        IF PDILine.FINDSET THEN
            REPEAT
                GatepassLine.RESET;
                GatepassLine.SETRANGE("Document No.", GatepassHeader."Document No");
                GatepassLine.SETRANGE("Ext Document No.", "No.");
                GatepassLine.SETRANGE("Item No.", PDILine."No.");
                IF NOT GatepassLine.FINDFIRST THEN BEGIN
                    LineNo := 0;
                    GatepassLine.RESET;
                    IF GatepassLine.FINDLAST THEN
                        LineNo := GatepassLine."Line No." + 1;
                    GatepassLine.INIT;
                    GatepassLine."Line No." := LineNo;
                    GatepassLine."Document Type" := GatepassLine."Document Type"::"Vehicle Service";
                    IF PDILine."Repair Type" = PDILine."Repair Type"::"Ext. Service" THEN BEGIN
                        GatepassLine."Item Type" := GatepassLine."Item Type"::"Ext. Service";
                        GatepassLine.VALIDATE("Item No.", PDILine."No.");
                    END
                    ELSE
                        IF PDILine."Repair Type" = PDILine."Repair Type"::Item THEN BEGIN
                            GatepassLine."Item Type" := GatepassLine."Item Type"::Spares;
                            GatepassLine.VALIDATE("Item No.", PDILine."No.");
                        END;
                    GatepassLine."Document No." := GatepassHeader."Document No";
                    GatepassLine.Quantity := PDILine.Quantity;
                    GatepassLine."Ext Document No." := GatepassHeader."External Document No.";
                    GatepassLine.INSERT(TRUE);
                END;
            UNTIL PDILine.NEXT = 0;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
    end;
}

