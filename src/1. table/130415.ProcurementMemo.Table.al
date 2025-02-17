table 130415 "Procurement Memo"
{

    fields
    {
        field(1; "Memo No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Memo No." <> xRec."Memo No." THEN BEGIN
                    IF "Procurement Type" = "Procurement Type"::Purchase THEN BEGIN
                        PurchasePaySet.GET;
                        PurchasePaySet.TESTFIELD(PurchasePaySet."Memo Nos.");
                        "No. Series" := '';
                        NoSeriesMgt.SetSeries("Memo No.");
                    END ELSE
                        IF "Procurement Type" = "Procurement Type"::Sales THEN BEGIN
                            PurchasePaySet.GET;
                            PurchasePaySet.TESTFIELD(PurchasePaySet."Sales Memo Nos");
                            "No. Series" := '';
                            NoSeriesMgt.SetSeries("Memo No.");
                        END ELSE
                            IF "Procurement Type" = "Procurement Type"::"Veh. Sales Memo" THEN BEGIN
                                PurchasePaySet.GET;
                                PurchasePaySet.TESTFIELD("Veh. Sales Memo Nos");
                                "No. Series" := '';
                                NoSeriesMgt.SetSeries("Memo No.");
                            END;
                END;
            end;
        }
        field(2; "Posting Date"; Date)
        {
        }
        field(3; "Document Date"; Date)
        {
        }
        field(4; Status; Option)
        {
            Editable = true;
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment","Pending IC Processing";
        }
        field(5; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; Posted; Boolean)
        {
        }
        field(50000; Background; Text[250])
        {
        }
        field(50001; "Rejection Reason"; Text[250])
        {
        }
        field(50002; "From Department"; Code[50])
        {
            TableRelation = "Location Master".Code;
        }
        field(50003; "From Department Name"; Text[50])
        {
        }
        field(50004; "User ID"; Code[50])
        {
        }
        field(50005; Subject; Text[250])
        {
        }
        field(50006; "Department Code"; Code[20])
        {
            TableRelation = "Location Master".Code;

            trigger OnValidate()
            begin
                MasterRec.RESET; //Yougesh 6/8/2022
                MasterRec.SETRANGE(Code, "Department Code");
                IF MasterRec.FINDFIRST THEN BEGIN
                    "Department Name" := MasterRec.Description;
                END;
            end;
        }
        field(50007; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(50008; "Procurement Type"; Option)
        {
            OptionMembers = " ",Sales,Purchase,"Veh. Sales Memo";
        }
        field(50009; "Advance Payment"; Decimal)
        {
        }
        field(50010; Background1; Text[250])
        {
        }
        field(50011; VIN; Boolean)
        {
        }
        field(50012; Remarks; Text[250])
        {
        }
        field(50013; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Vendor Line".Amount WHERE("Memo No." = FIELD("Memo No."),
                                                          Selected = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Memo No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Document Date" := TODAY;
        "User ID" := USERID;
        IF "Memo No." = '' THEN BEGIN
            PurchasePaySet.GET;
            IF "Procurement Type" = "Procurement Type"::Purchase THEN BEGIN
                PurchasePaySet.TESTFIELD("Memo Nos.");
                CLEAR(NoSeriesMgt);
                NoSeriesMgt.InitSeries(PurchasePaySet."Memo Nos.", xRec."No. Series", "Document Date", "Memo No.", Rec."No. Series");
            END ELSE IF "Procurement Type" = "Procurement Type"::Sales THEN BEGIN
                PurchasePaySet.TESTFIELD("Sales Memo Nos");
                CLEAR(NoSeriesMgt);
                NoSeriesMgt.InitSeries(PurchasePaySet."Sales Memo Nos", xRec."No. Series", "Document Date", "Memo No.", Rec."No. Series");
            END ELSE IF "Procurement Type" = "Procurement Type"::"Veh. Sales Memo" THEN BEGIN
                PurchasePaySet.TESTFIELD("Veh. Sales Memo Nos");
                CLEAR(NoSeriesMgt);
                NoSeriesMgt.InitSeries(PurchasePaySet."Veh. Sales Memo Nos", xRec."No. Series", "Document Date", "Memo No.", Rec."No. Series");
            END;
        END;
    end;

    trigger OnModify()
    begin
        "Posting Date" := TODAY;
    end;

    var
        PurchasePaySet: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GLBudgetEntry: Record "G/L Budget Entry";
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        MasterRec: Record "Location Master";
}

