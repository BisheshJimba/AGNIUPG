codeunit 25006323 "Item Ledger Entry-Veh. Reserve"
{
    Permissions = TableData 337 = rimd;

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure FilterReservFor(var FilterReservEntry: Record "337"; ItemLedgEntry: Record "32")
    begin
        FilterReservEntry.SETRANGE("Source Type", DATABASE::"Item Ledger Entry");
        FilterReservEntry.SETRANGE("Source Subtype", 0);
        FilterReservEntry.SETRANGE("Source ID", '');
        FilterReservEntry.SETRANGE("Source Batch Name", '');
        FilterReservEntry.SETRANGE("Source Ref. No.", ItemLedgEntry."Entry No.");
    end;
}

