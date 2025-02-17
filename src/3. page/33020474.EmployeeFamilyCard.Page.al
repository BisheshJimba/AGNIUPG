page 33020474 "Employee Family Card"
{
    PageType = Card;
    SourceTable = Table33020411;

    layout
    {
        area(content)
        {
            group("Employee Detail")
            {
                field("Emp Family No."; "Emp Family No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                }
            }
            group("Family Detail")
            {
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field(District; District)
                {
                }
                field(Gender; Gender)
                {
                }
                field("Date of Birth"; "Date of Birth")
                {
                }
                field("Email Address"; "Email Address")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Relation; Relation)
                {
                }
                field(Married; Married)
                {
                }
                field("Married Date"; "Married Date")
                {
                }
                field(Employed; Employed)
                {
                    Importance = Standard;
                }
                field(Designation; Designation)
                {
                }
                field(Office; Office)
                {
                }
                field("Joined On"; "Joined On")
                {
                }
                field("Work Details"; "Work Details")
                {
                }
                field("Date of Demise"; "Date of Demise")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ConfirmPost := DIALOG.CONFIRM(text0001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        EmpFamilyRec.RESET;
                        EmpFamilyRec.SETRANGE("Emp Family No.", "Emp Family No.");
                        IF EmpFamilyRec.FINDFIRST THEN BEGIN
                            IF EmpFamilyRec.Posted = FALSE THEN BEGIN
                                Posted := TRUE;
                                "Posted Date" := TODAY;
                                "Posted By" := USERID;
                                EmpFamilyRec.MODIFY;
                                MESSAGE(text0002);
                            END ELSE BEGIN
                                MESSAGE(text0003);
                            END;
                        END;
                    END;
                end;
            }
        }
    }

    var
        ConfirmPost: Boolean;
        EmpFamilyRec: Record "33020411";
        text0001: Label 'Do you want to Post?';
        text0002: Label 'Sucessfully Posted';
        text0003: Label 'Data Sucessfully Modified';
}

