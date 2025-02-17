pageextension 50297 pageextension50297 extends "Fixed Asset G/L Journal"
{
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".

        addfirst("Control 1")
        {
            field("Line No."; Rec."Line No.")
            {
            }
        }
        addafter("Control 115")
        {
            field("Debit Amount"; Rec."Debit Amount")
            {
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
            }
        }
        addafter("Control 113")
        {
            field("Document Class"; "Document Class")
            {
                Visible = false;
            }
            field("Document Subclass"; "Document Subclass")
            {
                Visible = false;
            }
        }
    }
    actions
    {
        addafter("Action 124")
        {
            action("&Get Standard Journals")
            {
                Image = GetStandardJournal;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    StdGenJnl: Record "750";
                begin
                    StdGenJnl.FILTERGROUP := 2;
                    StdGenJnl.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    StdGenJnl.FILTERGROUP := 0;

                    IF PAGE.RUNMODAL(PAGE::"Standard General Journals", StdGenJnl) = ACTION::LookupOK THEN BEGIN
                        StdGenJnl.CreateGenJnlFromStdJnl(StdGenJnl, CurrentJnlBatchName);
                        MESSAGE(Text000, StdGenJnl.Code);
                    END;
                    CurrPage.UPDATE(TRUE);
                end;
            }
            action("&Save as Standard Journal")
            {
                Image = SaveasStandardJournal;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJnlBatch: Record "232";
                    GeneralJnlLines: Record "81";
                    StdGenJnl: Record "750";
                    SaveAsStdGenJnl: Report "750";
                begin
                    BEGIN
                        GeneralJnlLines.SETFILTER("Journal Template Name", Rec."Journal Template Name");
                        GeneralJnlLines.SETFILTER("Journal Batch Name", CurrentJnlBatchName);
                        CurrPage.SETSELECTIONFILTER(GeneralJnlLines);
                        GeneralJnlLines.COPYFILTERS(Rec);

                        GenJnlBatch.GET(Rec."Journal Template Name", CurrentJnlBatchName);
                        SaveAsStdGenJnl.Initialise(GeneralJnlLines, GenJnlBatch);
                        SaveAsStdGenJnl.RUNMODAL;
                        IF NOT SaveAsStdGenJnl.GetStdGeneralJournal(StdGenJnl) THEN
                            EXIT;

                        MESSAGE(Text001, StdGenJnl.Code);
                    END;
                end;
            }
        }
    }

    var
        Text000: Label 'General Journal lines have been successfully inserted from Standard General Journal %1.';
        Text001: Label 'Standard General Journal %1 has been successfully created.';
}

