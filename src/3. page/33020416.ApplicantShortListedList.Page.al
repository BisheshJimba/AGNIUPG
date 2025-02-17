page 33020416 "Applicant ShortListed List"
{
    CardPageID = "Application New Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020382;
    SourceTableView = WHERE(ShortList = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; "Application No.")
                {
                }
                field("Vacancy Code"; "Vacancy Code")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field(Gender; Gender)
                {
                }
                field(Nationality; Nationality)
                {
                }
                field(Email; Email)
                {
                }
                field(CellPhone; CellPhone)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000014>")
            {
                Caption = 'Function';
                action("<Action1000000015>")
                {
                    Caption = 'Import Applicant Data';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 33020317;

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
                            XMLPORT.IMPORT(50012, CurrStream);
                            IF NOT ISSERVICETIER THEN CurrFile.CLOSE;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //App_New.COPYFILTERS(Rec);
        FILTERGROUP(2);
        SETRANGE(Status, Rec.Status::Shortlist);

        FILTERGROUP(0);
    end;

    var
        App_New: Record "33020382";
}

