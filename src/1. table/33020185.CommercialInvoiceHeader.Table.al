table 33020185 "Commercial Invoice Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    SalesReceiableSetup.GET;
                    NoSeriesMgmt.TestManual(SalesReceiableSetup."Commercial Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Date; Date)
        {
        }
        field(4; "Buyer Order No"; Code[20])
        {
        }
        field(5; "Buyer Order Date"; Date)
        {
        }
        field(7; "Pre-Carriage By"; Code[10])
        {
            TableRelation = "Shipment Method";
        }
        field(8; "Place of Recpt By Pre-Carrier"; Text[30])
        {
        }
        field(9; "Country of Origin"; Text[30])
        {
        }
        field(12; "Port of Loading"; Code[50])
        {
        }
        field(13; "Port of Discharge"; Code[50])
        {
        }
        field(14; "Final Destination"; Code[50])
        {
        }
        field(15; "Terms Of Del. & Payment"; Text[50])
        {
        }
        field(16; "Consignment No"; Code[10])
        {
        }
        field(17; Incoterms; Option)
        {
            OptionCaption = ' ,C&F,CIF,CIP,EX-WORKS,FOB,CFR,C&I,CNI';
            OptionMembers = " ","C&F",CIF,CIP,"EX-WORKS",FOB,CFR,"C&I",CNI;
        }
        field(18; "Payment Bank No"; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                CALCFIELDS("Payment Bank Name");
            end;
        }
        field(19; "Payment Bank Name"; Text[50])
        {
            CalcFormula = Lookup("Bank Account".Name WHERE(No.=FIELD(Payment Bank No)));
                FieldClass = FlowField;
        }
        field(108; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(109; "Posted Sales Inv. No."; Code[20])
        {
        }
        field(50000; "Location Code"; Code[100])
        {
        }
        field(50050; "Document Negotiation No."; Code[20])
        {
        }
        field(50055; "Domestic LC Margin No."; Code[20])
        {
        }
        field(50075; "Loan Payment Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE(Commercial Invoice No=FIELD(No),
                                                        Loan Posting Type=FILTER(Loan Payment),
                                                        G/L Account No.=FILTER(204461..204669)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50076;Amount;Decimal)
        {
            CalcFormula = Sum("Commercial Invoice Line".Amount WHERE (Document No.=FIELD(No)));
            FieldClass = FlowField;
        }
        field(50077;"Incoterms Address";Text[100])
        {
        }
        field(33020011;"Sys. LC No.";Code[20])
        {
            Caption = 'LC No.';
            TableRelation = "LC Details";

            trigger OnValidate()
            var
                LCDetail: Record "33020012";
                LCAmendDetail: Record "33020013";
                Text33020011: Label 'LC has amendments and amendment is not released.';
                Text33020012: Label 'LC has amendments and  amendment is closed.';
                Text33020013: Label 'LC Details is not released.';
                Text33020014: Label 'LC Details is closed.';
            begin
                CALCFIELDS("Bank LC No.","LC Value");
            end;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
            CalcFormula = Lookup("LC Details"."LC\DO No." WHERE (No.=FIELD(Sys. LC No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020013;Posted;Boolean)
        {
        }
        field(33020014;Narration;Text[250])
        {
        }
        field(33020015;"Bank Name";Text[100])
        {
        }
        field(33020016;"Bank Address";Text[100])
        {
        }
        field(33020017;"Freight Amount";Text[100])
        {
        }
        field(33020018;"Customer name";Text[50])
        {
            CalcFormula = Lookup("LC Details"."Issued To/Received From Name" WHERE (No.=FIELD(Sys. LC No.)));
            FieldClass = FlowField;
        }
        field(33020019;"LC Value";Decimal)
        {
            CalcFormula = Lookup("LC Details"."LC Value (LCY)" WHERE (No.=FIELD(Sys. LC No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF No = '' THEN BEGIN
          SalesReceiableSetup.GET;
          SalesReceiableSetup.TESTFIELD("Commercial Nos.");
          NoSeriesMgmt.InitSeries(SalesReceiableSetup."Commercial Nos.",xRec."No. Series",0D,No,"No. Series");
        END;
    end;

    var
        SalesReceiableSetup: Record "311";
        NoSeriesMgmt: Codeunit "396";
        CommercialHeader: Record "33020185";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        WITH CommercialHeader DO BEGIN
          CommercialHeader := Rec;
          SalesReceiableSetup.GET;
          SalesReceiableSetup.TESTFIELD("Commercial Nos.");
          IF NoSeriesMgmt.SelectSeries(SalesReceiableSetup."Commercial Nos.",xRec."No. Series","No. Series") THEN BEGIN
            SalesReceiableSetup.GET;
            SalesReceiableSetup.TESTFIELD("Commercial Nos.");
            NoSeriesMgmt.SetSeries(No);
            Rec := CommercialHeader;
            EXIT(TRUE);
          END;
        END;
    end;
}

