table 33019978 "QR Details"
{

    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = ' ,Sales Pick,Transfer Pick,Physical Inventory';
            OptionMembers = " ","Sales Pick","Transfer Pick","Physical Inventory";
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(11; "Item No."; Code[20])
        {
        }
        field(12; "QR Text"; Code[250])
        {

            trigger OnValidate()
            var
                QRDetail: Record "33019978";
                countrec: Integer;
            begin
                /*QRDetail.RESET;
                QRDetail.SETRANGE("Document No.","Document No.");
                //QRDetail.SETFILTER("Line No.",'<>%1',"Line No.");
                QRDetail.DELETEALL;
                */

                TESTFIELD(Type);
                TESTFIELD("Document No.");
                //TESTFIELD("Item No.");
                IF Type = Type::"Physical Inventory" THEN BEGIN
                    TESTFIELD("Location Code");
                    TESTFIELD("Bin Code");
                END;

                CASE Type OF
                    Type::"Sales Pick":
                        BEGIN
                            SalesHeader.GET(SalesHeader."Document Type"::Order, "Document No.");
                            CurrentlyScanningItemNo := QRMgt.AssignLotNoToSalesLine(SalesHeader, "QR Text", Settings, 0);
                        END;
                    Type::"Transfer Pick":
                        BEGIN
                            TransferHdr.GET("Document No.");
                            CurrentlyScanningItemNo := QRMgt.AssignLotNoToTransferLine(TransferHdr, "QR Text", Settings, 0);
                        END;
                END;

            end;
        }
        field(13; "Location Code"; Code[10])
        {
        }
        field(14; "Bin Code"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; Type, "Document No.", "QR Text")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        QRDetail: Record "33019978";
        LineNo: Integer;
    begin
        QRDetail.RESET;
        QRDetail.SETRANGE(Type, Type);
        QRDetail.SETRANGE("Document No.", "Document No.");
        IF QRDetail.FINDLAST THEN
            "Line No." := QRDetail."Line No." + 10000
        ELSE
            "Line No." := 10000;
    end;

    var
        QRMgt: Codeunit "50006";
        CurrentlyScanningItemNo: Code[20];
        SalesHeader: Record "36";
        Settings: array[50] of Boolean;
        TransferHdr: Record "5740";
}

