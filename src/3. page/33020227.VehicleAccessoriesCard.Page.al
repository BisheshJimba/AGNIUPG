page 33020227 "Vehicle Accessories Card"
{
    PageType = Card;
    SourceTable = Table33020179;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE();
                    end;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {

                    trigger OnValidate()
                    var
                        Text000: Label 'Accessories for Vehicle %1 has already been issued. Do you want to continue? If yes, you must specify the Reason Code.';
                    begin
                        ReasonCodeDisplay := FALSE;
                        "Reason Code" := '';
                        IF VerifySerialNo("Vehicle Serial No.") THEN BEGIN
                            IF CONFIRM(Text000, TRUE, "Vehicle Serial No.") THEN
                                ReasonCodeDisplay := TRUE
                            ELSE BEGIN
                                ERROR('Process Cancelled.');
                            END;
                        END;
                        CALCFIELDS(VIN, "Make Code", "Model Code", "Model Version No.");

                        CurrPage.UPDATE;
                    end;
                }
                field("Vendor Code"; "Vendor Code")
                {

                    trigger OnValidate()
                    begin
                        CALCFIELDS("Vendor Name");
                    end;
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
                field("Customer Code"; "Customer Code")
                {

                    trigger OnValidate()
                    begin
                        CALCFIELDS("Customer Name");
                    end;
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(Description; Description)
                {
                }
                field("Reason Code"; "Reason Code")
                {
                    Editable = reasoncodedisplay;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field(Approved; Approved)
                {
                }
            }
            part("Accessories Line"; 33020228)
            {
                SubPageLink = Document No.=FIELD(No.);
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
            group("<Action1000000004>")
            {
                Caption = 'Posting';
                action("<Action75>")
                {
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        Text000: Label 'Do you want post the Document %1?';
                    begin
                        IF CONFIRM(Text000, TRUE, "No.") THEN BEGIN
                            CurrPage.SETSELECTIONFILTER(VehAccHeader);
                            PostDocument(Rec);
                            REPORT.RUNMODAL(33020176, FALSE, FALSE, VehAccHeader);
                        END;
                    end;
                }
            }
            group("<Action1000000017>")
            {
                Caption = 'F&unctions';
                action("<Action1000000018>")
                {
                    Caption = 'Approve';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text000: Label 'Do you want to approve selected Memos?';
                        VehAcc: Record "33020179";
                    begin
                        IF CONFIRM(Text000, TRUE) THEN BEGIN
                            SetRecSelectionFilter(VehAcc);
                            IF SetLineSelection(VehAcc) THEN
                                MESSAGE('Documents approved Successfully.');
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ReasonCodeDisplay := FALSE;
        IF VerifySerialNo("Vehicle Serial No.") THEN
            ReasonCodeDisplay := TRUE
    end;

    var
        [InDataSet]
        ReasonCodeDisplay: Boolean;
        VehAccHeader: Record "33020179";

    [Scope('Internal')]
    procedure SetRecSelectionFilter(var VehAccHeader: Record "33020179")
    begin
        CurrPage.SETSELECTIONFILTER(VehAccHeader);
    end;
}

