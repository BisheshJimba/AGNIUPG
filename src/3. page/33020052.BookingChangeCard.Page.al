page 33020052 "Booking Change Card"
{
    PageType = Card;
    SourceTable = Table33019857;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Vehicle No."; "Vehicle No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Previous Customer No."; "Previous Customer No.")
                {
                }
                field("New Customer No."; "New Customer No.")
                {
                }
                field("Previous Customer Name"; "Previous Customer Name")
                {
                }
                field("New Customer Name"; "New Customer Name")
                {
                }
                field(Reason; Reason)
                {
                }
                field(Date; Date)
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
        area(creation)
        {
            group("<Action1000000007>")
            {
                Caption = 'Post Action';
                action("<Action1102159020>")
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ConfirmPost := DIALOG.CONFIRM(text001, TRUE);
                        IF ConfirmPost THEN BEGIN
                            BookingChangePost;
                            MESSAGE(text003);
                        END
                        ELSE
                            MESSAGE(text002, USERID);
                    end;
                }
            }
        }
    }

    var
        ConfirmPost: Boolean;
        text001: Label 'Do you want to change the Customer No.?';
        text002: Label 'Aborted by user - %1!';
        text003: Label 'Customer No. is changed  successfully!';
        VehBookingChangeLog: Record "33019856";
        BookingChange: Record "33019857";
        VehRec: Record "25006005";

    [Scope('Internal')]
    procedure BookingChangePost()
    begin
        VehBookingChangeLog.INIT;
        VehBookingChangeLog."Entry No." := "No.";
        VehBookingChangeLog."Vehicle No." := "Vehicle No.";
        VehBookingChangeLog.VIN := VIN;
        VehBookingChangeLog."Previous Customer No." := "Previous Customer No.";
        VehBookingChangeLog."New Customer No." := "New Customer No.";
        VehBookingChangeLog."Previous Customer Name" := "Previous Customer Name";
        VehBookingChangeLog."New Customer Name" := "New Customer Name";
        VehBookingChangeLog.Reason := Reason;
        //VehBookingChangeLog."User ID" := "User ID";

        VehBookingChangeLog.TESTFIELD("New Customer No.");
        VehBookingChangeLog.INSERT(TRUE);

        BookingChange.DELETEALL;

        //To update Customer No. in Vehicle Card
        VehRec.RESET;
        VehRec.SETRANGE("Serial No.", "Vehicle No.");
        IF VehRec.FINDFIRST THEN BEGIN
            VehRec."Customer No." := "New Customer No.";
            VehRec.MODIFY;
        END;






        // To Update in Fixed Asset
        /*
        FixAsset.SETRANGE(FixAsset."No.","FA No.");
        IF FixAsset.FINDFIRST THEN BEGIN
           FixAsset."FA Location Code" := "To Location Code";
           FixAsset."Responsible Employee" := "To Resposible Emp";
           FixAsset.MODIFY;
        END;
        
        COMMIT;
        */

    end;
}

