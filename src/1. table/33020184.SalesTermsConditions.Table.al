table 33020184 "Sales Terms & Conditions"
{
    Caption = 'Sales Terms & Conditions';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,"Posted Invoice","Posted Credit Memo","Posted Return Receipt";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(6; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(7; "Customer No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            begin
                "No." := "Customer No.";
            end;
        }
        field(8; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",,"External Service";
        }
        field(9; "Component No."; Code[20])
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(G/L Account)) "G/L Account" WHERE (Direct Posting=CONST(Yes),
                                                                                   Account Type=CONST(Posting),
                                                                                   Blocked=CONST(No));

            trigger OnValidate()
            begin
                IF (Type = Type::"G/L Account") THEN BEGIN
                    GLAcc.GET("Component No.");
                    GLAcc.CheckGLAcc;
                    GLAcc.TESTFIELD("Direct Posting", TRUE);
                    Description := GLAcc.Name;
                END;
            end;
        }
        field(10; Description; Text[50])
        {
        }
        field(11; Quantity; Decimal)
        {
        }
        field(12; "Unit Price"; Decimal)
        {
        }
        field(13; "Location Code"; Code[10])
        {
            TableRelation = Location WHERE(Use As In-Transit=CONST(No));
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Line No." := xRec."Line No." + 10000;
    end;

    var
        GLAcc: Record "15";

    [Scope('Internal')]
    procedure SetUpNewLine()
    var
        SalesCommentLine: Record "33020184";
    begin
        SalesCommentLine.SETRANGE("Document Type", "Document Type");
        SalesCommentLine.SETRANGE("No.", "No.");
        SalesCommentLine.SETRANGE(Date, WORKDATE);
        IF NOT SalesCommentLine.FIND('-') THEN
            Date := WORKDATE;
    end;
}

