page 33019982 "File Management Setup"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = Table33020795;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Resp Center / Jou Temp"; "Resp Center / Jou Temp")
                {
                }
                field("File No. Series"; "File No. Series")
                {
                }
                field("Default Rack Location"; "Default Rack Location")
                {
                }
                field("Default Room No."; "Default Room No.")
                {
                }
                field("Default Rack No."; "Default Rack No.")
                {
                }
                field("Default Sub Rack No."; "Default Sub Rack No.")
                {
                }
                field("Header Text 1"; "Header Text 1")
                {
                }
                field("Header Text 2"; "Header Text 2")
                {
                }
                field("Header Text 3"; "Header Text 3")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; MyNotes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("<Action1000000008>")
            {
                Caption = 'Assign File';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TESTFIELD("File No. Series");

                    FIleDetails.RESET;
                    FIleDetails.SETRANGE("Document Type", "Document Type");
                    FIleDetails.SETRANGE("Resp Center / Jou Temp", "Resp Center / Jou Temp");
                    IF NOT FIleDetails.ISEMPTY THEN
                        ERROR('File already assigned, you can only close the file');

                    FIleDetailsIns.INIT;
                    FIleDetailsIns."Document Type" := "Document Type";
                    FIleDetailsIns."Resp Center / Jou Temp" := "Resp Center / Jou Temp";
                    FIleDetailsIns."File No." := NoseriesMgt.GetNextNo("File No. Series", TODAY, TRUE);
                    FIleDetailsIns."Creation Date" := TODAY;
                    FIleDetailsIns.INSERT;

                    FIleDetails.RESET;
                    FIleDetails.SETRANGE("Document Type", "Document Type");
                    FIleDetails.SETRANGE("Resp Center / Jou Temp", "Resp Center / Jou Temp");
                    FileDetailsPage.SETTABLEVIEW(FIleDetails);
                    FileDetailsPage.RUN;
                end;
            }
            action("<Action1000000009>")
            {
                Caption = 'Close File';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    /*IF NOT CONFIRM('Are you Sure you want to close the file',FALSE) THEN
                      EXIT
                    ELSE BEGIN
                      FIleDetails.RESET;
                      FIleDetails.SETRANGE("Document Type","Document Type");
                      FIleDetails.SETRANGE("Resp Center / Jou Temp","Resp Center / Jou Temp");
                      FIleDetails.SETRANGE(Close,FALSE);
                      IF NOT FIleDetails.FINDFIRST THEN
                        ERROR('Nothing to close the file')
                      ELSE BEGIN
                        FIleDetails."Closing Date" := TODAY;
                        FIleDetails.Close := TRUE;
                        FIleDetails.MODIFY;
                        ClosedFile := FIleDetails."File No.";
                      END;
                    
                      FIleDetailsIns.INIT;
                      FIleDetailsIns."Document Type":= "Document Type";
                      FIleDetailsIns."Resp Center / Jou Temp" := "Resp Center / Jou Temp";
                      FIleDetailsIns."File No."      := NoseriesMgt.GetNextNo("File No. Series",TODAY,TRUE);
                      FIleDetailsIns."Creation Date" := TODAY;
                      FIleDetailsIns.INSERT;
                      // Temperarily Commented until Print format has completed >>
                    
                      FIleDetails.RESET;
                      FIleDetails.SETRANGE("Document Type","Document Type");
                      FIleDetails.SETRANGE("Resp Center / Jou Temp","Resp Center / Jou Temp");
                      FIleDetails.SETRANGE("File No.",ClosedFile);
                      FIleDetails.SETRANGE(Close,TRUE);
                      REPORT.RUNMODAL(33020141,FALSE,FALSE,FIleDetails);
                    
                      // Temperarily Commented until Print format has completed <<
                    END;*/
                    CloseFile;

                end;
            }
            action("<Action1000000011>")
            {
                Caption = 'Show File Details';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = View;

                trigger OnAction()
                begin
                    FIleDetails.RESET;
                    FIleDetails.SETRANGE("Document Type", "Document Type");
                    FIleDetails.SETRANGE("Resp Center / Jou Temp", "Resp Center / Jou Temp");
                    FileDetailsPage.SETTABLEVIEW(FIleDetails);
                    FileDetailsPage.RUN;
                end;
            }
            action("<Action1000000010>")
            {
                Caption = 'Print File Format (Manual)';
                RunObject = Report 33020141;
            }
        }
    }

    var
        UserSetup: Record "91";
        PageFilter: Code[100];
        FIleDetails: Record "33020798";
        FIleDetailsIns: Record "33020798";
        FileDetailsPage: Page "33019983";
        NoseriesMgt: Codeunit "396";
        ClosedFile: Code[20];
}

