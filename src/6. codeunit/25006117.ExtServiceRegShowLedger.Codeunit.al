codeunit 25006117 "Ext. Service Reg.-Show Ledger"
{
    TableNo = 25006152;

    trigger OnRun()
    begin
        ExtServiceLedgEntry.SETRANGE("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        PAGE.RUN(PAGE::"Ext. Service Ledger Entries", ExtServiceLedgEntry);
    end;

    var
        ExtServiceLedgEntry: Record "25006137";
}

