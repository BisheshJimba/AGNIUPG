page 50050 "Dimension Setup Table List"
{
    PageType = List;
    SourceTable = Table14125600;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table ID"; "Table ID")
                {
                }
                field("Table Caption"; "Table Caption")
                {
                }
                field("Primary Key 1"; "Primary Key 1")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Primary Key 1"));
                    end;
                }
                field("Primary Key 2"; "Primary Key 2")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Primary Key 2"));
                    end;
                }
                field("Primary Key 3"; "Primary Key 3")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Primary Key 3"));
                    end;
                }
                field("Primary Key 4"; "Primary Key 4")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Primary Key 4"));
                    end;
                }
                field("Document No. Field No."; "Document No. Field No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Document No. Field No."));
                    end;
                }
                field("Dimension Set Id - Field No."; "Dimension Set Id - Field No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Dimension Set Id - Field No."));
                    end;
                }
                field("Dimension 1 - Field No."; "Dimension 1 - Field No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Dimension 1 - Field No."));
                    end;
                }
                field("Dimension 2 - Field No."; "Dimension 2 - Field No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Dimension 2 - Field No."));
                    end;
                }
                field("Dimension 3 - Field No."; "Dimension 3 - Field No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Dimension 3 - Field No."));
                    end;
                }
                field("Dimension 4 - Field No."; "Dimension 4 - Field No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Dimension 4 - Field No."));
                    end;
                }
                field("Dimension 5 - Field No."; "Dimension 5 - Field No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Dimension 5 - Field No."));
                    end;
                }
                field("Dimension 6 - Field No."; "Dimension 6 - Field No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Dimension 6 - Field No."));
                    end;
                }
                field("Dimension 7 - Field No."; "Dimension 7 - Field No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Dimension 7 - Field No."));
                    end;
                }
                field("Dimension 8 - Field No."; "Dimension 8 - Field No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AssistEdit(FIELDNO("Dimension 8 - Field No."));
                    end;
                }
                field(Skip; Skip)
                {
                }
            }
        }
    }

    actions
    {
    }

    local procedure AssistEdit(NewFieldNo: Integer)
    var
        "Field": Record "2000000041";
        ChangeLogSetupFieldList: Page "50042";
    begin
        Field.FILTERGROUP(2);
        Field.SETRANGE(TableNo, "Table ID");
        Field.FILTERGROUP(0);

        CLEAR(ChangeLogSetupFieldList);
        ChangeLogSetupFieldList.SETTABLEVIEW(Field);
        ChangeLogSetupFieldList.SETRECORD(Field);
        ChangeLogSetupFieldList.LOOKUPMODE(TRUE);
        IF ChangeLogSetupFieldList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ChangeLogSetupFieldList.GETRECORD(Field);
            CASE NewFieldNo OF
                FIELDNO("Primary Key 1"):
                    "Primary Key 1" := Field."No.";
                FIELDNO("Primary Key 2"):
                    "Primary Key 2" := Field."No.";
                FIELDNO("Primary Key 3"):
                    "Primary Key 3" := Field."No.";
                FIELDNO("Primary Key 4"):
                    "Primary Key 4" := Field."No.";
                FIELDNO("Dimension 1 - Field No."):
                    "Dimension 1 - Field No." := Field."No.";
                FIELDNO("Dimension 2 - Field No."):
                    "Dimension 2 - Field No." := Field."No.";
                FIELDNO("Dimension 3 - Field No."):
                    "Dimension 3 - Field No." := Field."No.";
                FIELDNO("Dimension 4 - Field No."):
                    "Dimension 4 - Field No." := Field."No.";
                FIELDNO("Dimension 5 - Field No."):
                    "Dimension 5 - Field No." := Field."No.";
                FIELDNO("Dimension 6 - Field No."):
                    "Dimension 6 - Field No." := Field."No.";
                FIELDNO("Dimension 7 - Field No."):
                    "Dimension 7 - Field No." := Field."No.";
                FIELDNO("Dimension 8 - Field No."):
                    "Dimension 8 - Field No." := Field."No.";
                FIELDNO("Document No. Field No."):
                    "Document No. Field No." := Field."No.";
                FIELDNO("Dimension Set Id - Field No."):
                    "Dimension Set Id - Field No." := Field."No.";

            END;

        END;
    end;
}

