page 33020418 "Short Listed List"
{
    Caption = 'Short Listed List';
    CardPageID = "Applicant ShortList Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
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
                field(ShortList; ShortList)
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
                Caption = 'Functions';
                action("<Action1000000021>")
                {
                    Caption = 'Remove Shortlisted';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                        SetRecordSelection(ApplicationNew);
                        ApplicationNew.SETCURRENTKEY("Vacancy Code");
                        ApplicationNew.SETRANGE("Vacancy Code", "Vacancy Code");
                        IF ApplicationNew.FINDFIRST THEN BEGIN
                            ApplicationNew.ShortList := FALSE;
                            ApplicationNew."Posted by- Shortlist" := USERID;
                            ApplicationNew."Posted Date- Shortlist" := TODAY;
                            ApplicationNew.MODIFY;
                            MESSAGE(text0001);
                        END;
                    end;
                }
            }
        }
    }

    var
        ApplicationNew: Record "33020382";
        text0001: Label 'The applicant has been removed from short-list';

    [Scope('Internal')]
    procedure SetRecordSelection(var AppNew: Record "33020382")
    begin
        CurrPage.SETSELECTIONFILTER(AppNew);
    end;
}

