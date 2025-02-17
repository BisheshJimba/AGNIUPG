page 50022 "Gen. Journal Line Buffer"
{
    PageType = List;
    SourceTable = Table33019845;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Journal Template Name"; "Journal Template Name")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Debit Amount"; "Debit Amount")
                {
                }
                field("Credit Amount"; "Credit Amount")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Document Class"; "Document Class")
                {
                }
                field("Document Subclass"; "Document Subclass")
                {
                }
                field(Narration; Narration)
                {
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1102159013>")
            {
                Caption = '&Import Journal Line';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CurrFile: File;
                    CurrStream: InStream;
                    ClientFileName: Text[1024];
                    SelectCSVFile: Label 'Select the CSV Requisition File.';
                begin
                    BEGIN
                        IF ISSERVICETIER THEN BEGIN
                            IF NOT UPLOADINTOSTREAM(
                                              SelectCSVFile,
                                               'C:\',
                                               'XML File *.csv| *.csv',
                                                ClientFileName,
                                                CurrStream) THEN
                                EXIT;
                        END
                        ELSE BEGIN
                            CurrFile.OPEN('C:\');
                            CurrFile.CREATEINSTREAM(CurrStream);
                        END;
                        XMLPORT.IMPORT(50011, CurrStream);
                        IF NOT ISSERVICETIER THEN CurrFile.CLOSE;
                    END;
                end;
            }
            action("<Action1000000020>")
            {
                Caption = '&Process Data';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CopyToGenJnl;
                end;
            }
        }
    }
}

