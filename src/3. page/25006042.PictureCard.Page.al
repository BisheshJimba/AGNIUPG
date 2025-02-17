page 25006042 "Picture Card"
{
    InsertAllowed = false;
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = Table25006060;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Source Type"; "Source Type")
                {
                    Caption = 'Source Type';
                }
                field("Source Subtype"; "Source Subtype")
                {
                    Caption = 'Source Subtype';
                }
                field("Source ID"; "Source ID")
                {
                    Caption = 'Source ID';
                }
                field("Source Ref. No."; "Source Ref. No.")
                {
                    Caption = 'Source Ref. No.';
                }
                field(Description; Description)
                {
                    Caption = 'Description';
                }
                field(Imported; Imported)
                {
                    Caption = 'Imported';
                }
                field(Default; Default)
                {
                    Caption = 'Default';
                }
                field(BLOB; BLOB)
                {
                    Caption = 'Picture';
                }
                field("No. Series"; "No. Series")
                {
                    Caption = 'No. Series';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //VALIDATE("Source Type", SourceType);
        //VALIDATE("Source Subtype", "Source Subtype");
        //VALIDATE("Source ID", SourceID);
        //VALIDATE("Source Ref. No.", SourceRefNo);
    end;

    trigger OnOpenPage()
    begin
        //MESSAGE(GETFILTERS);
    end;

    var
        SourceType: Integer;
        SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10";
        SourceID: Code[20];
        SourceRefNo: Integer;

    [Scope('Internal')]
    procedure SetParameters(ParSourceType: Integer; ParSourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10"; ParSourceID: Code[20]; ParSourceRefNo: Integer)
    begin
        SourceType := ParSourceType;
        SourceSubtype := ParSourceSubtype;
        SourceID := ParSourceID;
        SourceRefNo := ParSourceRefNo;
    end;
}

