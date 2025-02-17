pageextension 50012 pageextension50012 extends "Customer Posting Groups"
{
    layout
    {
        addafter("Control 31")
        {
            field("Check Duplicate VAT Reg. No."; Rec."Check Duplicate VAT Reg. No.")
            {
            }
            field("Skip VAT Reg. No. Check"; Rec."Skip VAT Reg. No. Check")
            {
            }
        }
    }

    procedure GetSelectionFilter(): Code[80]
    var
        CustomerPostingGroup: Record "92";
        FirstVend: Code[30];
        LastVend: Code[30];
        SelectionFilter: Code[250];
        VendCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(CustomerPostingGroup);
        VendCount := CustomerPostingGroup.COUNT;
        IF VendCount > 0 THEN BEGIN
            CustomerPostingGroup.FIND('-');
            WHILE VendCount > 0 DO BEGIN
                VendCount := VendCount - 1;
                CustomerPostingGroup.MARKEDONLY(FALSE);
                FirstVend := CustomerPostingGroup.Code;
                LastVend := FirstVend;
                More := (VendCount > 0);
                WHILE More DO
                    IF CustomerPostingGroup.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT CustomerPostingGroup.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastVend := CustomerPostingGroup.Code;
                            VendCount := VendCount - 1;
                            IF VendCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstVend = LastVend THEN
                    SelectionFilter := SelectionFilter + FirstVend
                ELSE
                    SelectionFilter := SelectionFilter + FirstVend + '..' + LastVend;
                IF VendCount > 0 THEN BEGIN
                    CustomerPostingGroup.MARKEDONLY(TRUE);
                    CustomerPostingGroup.NEXT;
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;
}

