table 33020036 "Gate Entry Line"
{
    Caption = 'Gate Entry Line';

    fields
    {
        field(1; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Inward,Outward';
            OptionMembers = Inward,Outward;
        }
        field(2; "Gate Entry No."; Code[20])
        {
            Caption = 'Gate Entry No.';
            TableRelation = "Gate Entry Header".No. WHERE(Entry Type=FIELD(Entry Type));
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(4;"Source Type";Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Sales Shipment,Sales Return Order,Purchase Order,Purchase Return Shipment,Transfer Receipt,Transfer Shipment,Service';
            OptionMembers = " ","Sales Shipment","Sales Return Order","Purchase Order","Purchase Return Shipment","Transfer Receipt","Transfer Shipment",Service;

            trigger OnValidate()
            begin
                IF "Source Type" <> xRec."Source Type" THEN BEGIN
                  "Source No." := '';
                  "Source Name" := '';
                END;
            end;
        }
        field(5;"Source No.";Code[20])
        {
            Caption = 'Source No.';

            trigger OnLookup()
            begin

                GateEntryHeader.GET("Entry Type","Gate Entry No.");
                CASE "Source Type" OF
                  "Source Type"::"Sales Shipment":
                    BEGIN
                      SalesShipHeader.RESET;
                      SalesShipHeader.FILTERGROUP(2);
                      SalesShipHeader.SETRANGE("Location Code",GateEntryHeader."Location Code");
                      SalesShipHeader.FILTERGROUP(0);
                      IF PAGE.RUNMODAL(0,SalesShipHeader) = ACTION::LookupOK THEN
                        VALIDATE("Source No.",SalesShipHeader."No.");
                    END;
                  "Source Type"::"Sales Return Order":
                    BEGIN
                      SalesHeader.RESET;
                      SalesHeader.FILTERGROUP(2);
                      SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::"Return Order");
                      SalesHeader.SETRANGE("Location Code",GateEntryHeader."Location Code");
                      SalesHeader.FILTERGROUP(0);
                      IF PAGE.RUNMODAL(0,SalesHeader) = ACTION::LookupOK THEN
                        VALIDATE("Source No.",SalesHeader."No.");
                    END;
                  "Source Type"::"Purchase Order":
                    BEGIN
                      PurchHeader.RESET;
                      PurchHeader.FILTERGROUP(2);
                      PurchHeader.SETRANGE("Document Type",PurchHeader."Document Type"::Order);
                      PurchHeader.SETRANGE("Location Code",GateEntryHeader."Location Code");
                      PurchHeader.FILTERGROUP(0);
                      IF PAGE.RUNMODAL(0,PurchHeader)= ACTION::LookupOK THEN
                        VALIDATE("Source No.",PurchHeader."No.");
                    END;
                  "Source Type"::"Purchase Return Shipment":
                    BEGIN
                      ReturnShipHeader.RESET;
                      ReturnShipHeader.FILTERGROUP(2);
                      ReturnShipHeader.SETRANGE("Location Code",GateEntryHeader."Location Code");
                      ReturnShipHeader.FILTERGROUP(0);
                      IF PAGE.RUNMODAL(0,ReturnShipHeader)= ACTION::LookupOK THEN
                        VALIDATE("Source No.",ReturnShipHeader."No.");
                    END;
                  "Source Type"::"Transfer Receipt":
                    BEGIN
                      TransHeader.RESET;
                      TransHeader.FILTERGROUP(2);
                      TransHeader.SETRANGE("Transfer-to Code",GateEntryHeader."Location Code");
                      TransHeader.FILTERGROUP(0);
                      IF PAGE.RUNMODAL(0,TransHeader)= ACTION::LookupOK THEN
                        VALIDATE("Source No.",TransHeader."No.");
                    END;
                  "Source Type"::"Transfer Shipment":
                    BEGIN
                      TransShptHeader.RESET;
                      TransShptHeader.FILTERGROUP(2);
                      TransShptHeader.SETRANGE("Transfer-from Code",GateEntryHeader."Location Code");
                      TransShptHeader.FILTERGROUP(0);
                      IF PAGE.RUNMODAL(0,TransShptHeader)= ACTION::LookupOK THEN
                        VALIDATE("Source No.",TransShptHeader."No.");
                    END;
                  "Source Type"::Service:
                    BEGIN
                      SalesInvoiceHeader.RESET;
                      SalesInvoiceHeader.FILTERGROUP(2);
                      SalesInvoiceHeader.SETRANGE("Location Code",GateEntryHeader."Location Code");
                      SalesInvoiceHeader.FILTERGROUP(0);
                      IF PAGE.RUNMODAL(0,SalesInvoiceHeader)= ACTION::LookupOK THEN
                        VALIDATE("Source No.",SalesInvoiceHeader."No.");
                    END

                END;
            end;

            trigger OnValidate()
            begin

                IF "Source Type" = "Source Type"::" " THEN
                   ERROR(Text16500,FIELDCAPTION("Line No."),"Line No.");

                IF "Source No." <> xRec."Source No." THEN
                  "Source Name" := '';
                IF "Source No." = '' THEN BEGIN
                  "Source Name" := '';
                  EXIT;
                END;
                CASE "Source Type" OF
                  "Source Type"::"Sales Shipment":
                    BEGIN
                      SalesShipHeader.GET("Source No.");
                      "Source Name" := SalesShipHeader."Bill-to Name";
                   END;
                  "Source Type"::"Sales Return Order":
                    BEGIN
                      SalesHeader.GET(SalesHeader."Document Type"::"Return Order","Source No.");
                      "Source Name" := SalesHeader."Bill-to Name";
                    END;
                  "Source Type"::"Purchase Order":
                    BEGIN
                      PurchHeader.GET(PurchHeader."Document Type"::Order,"Source No.");
                      "Source Name" := PurchHeader."Pay-to Name";
                    END;
                  "Source Type"::"Purchase Return Shipment":
                    BEGIN
                      ReturnShipHeader.GET("Source No.");
                      "Source Name" := ReturnShipHeader."Pay-to Name";
                    END;
                  "Source Type"::"Transfer Receipt":
                    BEGIN
                      TransHeader.GET("Source No.");
                      "Source Name" := TransHeader."Transfer-from Name";
                   END;
                  "Source Type"::"Transfer Shipment":
                    BEGIN
                      TransShptHeader.GET("Source No.");
                      "Source Name" := TransShptHeader."Transfer-to Name";
                    END;
                  "Source Type"::Service:
                    BEGIN
                      SalesInvoiceHeader.GET("Source No.");
                      "Source Name" := SalesInvoiceHeader."Sell-to Customer Name";

                    END

                END;
            end;
        }
        field(6;"Source Name";Text[30])
        {
            Caption = 'Source Name';
            Editable = false;
        }
        field(7;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Close';
            OptionMembers = Open,Close;
        }
        field(8;Description;Text[80])
        {
            Caption = 'Description';
        }
        field(9;"Challan No.";Code[20])
        {
            Caption = 'Challan No.';
        }
        field(10;"Challan Date";Date)
        {
            Caption = 'Challan Date';
        }
    }

    keys
    {
        key(Key1;"Entry Type","Gate Entry No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PurchHeader: Record "38";
        SalesShipHeader: Record "110";
        TransHeader: Record "5740";
        SalesHeader: Record "36";
        ReturnShipHeader: Record "6650";
        TransShptHeader: Record "5744";
        GateEntryHeader: Record "33020035";
        Text16500: Label 'Source Type must not be blank in %1 %2.';
        SalesInvoiceHeader: Record "112";
}

