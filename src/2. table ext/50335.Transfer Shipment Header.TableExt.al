tableextension 50335 tableextension50335 extends "Transfer Shipment Header"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 22)".

        field(50000; Remarks; Text[100])
        {
        }
        field(50001; "User ID"; Code[50])
        {
            Editable = true;
        }
        field(50002; Tender; Boolean)
        {
        }
        field(50003; "Shipped By User"; Code[50])
        {
            TableRelation = User."User Name";
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006100; "Transfer-to Customer No."; Code[20])
        {
            Caption = 'Transfer-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Cust: Record "18";
            begin
                IF "Transfer-to Customer No." = '' THEN BEGIN
                    "Transfer-to Customer Name" := '';
                    EXIT;
                END;
                IF Cust.GET("Transfer-to Customer No.") THEN
                    "Transfer-to Customer Name" := Cust.Name;
            end;
        }
        field(25006110; "Transfer-to Customer Name"; Text[30])
        {
            Caption = 'Transfer-to Customer Name';
        }
        field(25006160; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            Editable = false;
        }
        field(25006166; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(25006200; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source Type=CONST(25006145)) "Service Header EDMS".No. WHERE (Document Type=FIELD(Source Subtype));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(33019831;"Invoice No.";Code[20])
        {
            CalcFormula = Lookup("Sales Invoice Header".No. WHERE (Service Order No.=FILTER(<>"),
                                                                   Document Profile=CONST(Service),
                                                                   Service Order No.=FIELD(Source No.)));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = IF (Source No.=FILTER(<>'')) "Sales Invoice Header".No. WHERE (Service Order No.=FIELD(Source No.));
        }
        field(33020236;"Courier Pod. No.";Code[30])
        {
        }
        field(33020237;"Courier Date";Date)
        {
        }
        field(33020238;Weight;Decimal)
        {
        }
        field(33020239;"Vehicle Registration No.";Code[20])
        {
        }
        field(33020240;"Document Date";Date)
        {
        }
        field(33020241;"Total CBM";Decimal)
        {
            CalcFormula = Sum("Transfer Shipment Line".CBM WHERE (Document No.=FIELD(No.)));
            DecimalPlaces = 0:6;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1;"Document Profile")
        {
        }
        key(Key2;"Document Profile","Source Type","Source Subtype","Source No.")
        {
        }
    }


    //Unsupported feature: Code Modification on "CopyFromTransferHeader(PROCEDURE 4)".

    //procedure CopyFromTransferHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Transfer-from Code" := TransHeader."Transfer-from Code";
        "Transfer-from Name" := TransHeader."Transfer-from Name";
        "Transfer-from Name 2" := TransHeader."Transfer-from Name 2";
        #4..18
        "Trsf.-to Country/Region Code" := TransHeader."Trsf.-to Country/Region Code";
        "Transfer-to Contact" := TransHeader."Transfer-to Contact";
        "Transfer Order Date" := TransHeader."Posting Date";
        "Posting Date" := TransHeader."Posting Date";
        "Shipment Date" := TransHeader."Shipment Date";
        "Receipt Date" := TransHeader."Receipt Date";
        "Shortcut Dimension 1 Code" := TransHeader."Shortcut Dimension 1 Code";
        #26..35
        "Entry/Exit Point" := TransHeader."Entry/Exit Point";
        Area := TransHeader.Area;
        "Transaction Specification" := TransHeader."Transaction Specification";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..21
        "Posting Date" := TODAY;
        #23..38
        Remarks := TransHeader.Remarks;
        "Document Date" := TransHeader."Document Date";
        SysMgt.OnAfterCopyTransferHeaderToTransShptHeader(TransHeader,Rec); //Agile 12/09/2018
        */
    //end;

    procedure GetLocationWiseRec(DocProfile: Option " ","Spare Parts Trade","Vehicles Trade",Service)
    begin
        Rec.RESET;
        SETRANGE("Document Profile",DocProfile);
        IF FINDFIRST THEN BEGIN
        UserSetup.GET(USERID);
          REPEAT
            IF ("Transfer-from Code" = UserSetup."Default Location") OR ("Transfer-from Code"='') OR
               ("Transfer-to Code" = UserSetup."Default Location") OR ("Transfer-to Code"='')THEN BEGIN
                  Rec.MARK(TRUE);
               END;
          UNTIL NEXT = 0;
        END;
    end;

    var
        UserSetup: Record "91";
        SysMgt: Codeunit "50000";
}

