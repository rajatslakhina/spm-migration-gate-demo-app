import SwiftUI
import MigrationGate
import MigrationGateUI

/// The app owns the gate policy: the tolerances a team would pin in CI when the migration starts.
/// The dashboard shows its fingerprint, and any submission built against a different policy is escalated.
enum DemoConfiguration {
    static let gatePolicy = GatePolicy(
        maxBinaryGrowthBytes: 64 * 1024,
        maxBinaryGrowthBasisPoints: 50,
        minLaunchSamples: 15,
        maxMedianLaunchRegressionMs: 15,
        maxP90LaunchRegressionMs: 30,
        allowedSymbolAdditionSubstrings: ["resource_bundle_accessor"],
        requireRollbackProof: true
    )

    /// `-tab gate|prompt|ledger` opens that tab and runs the scripted migration on launch (used for screenshots).
    static var initialTab: DashboardTab {
        let args = ProcessInfo.processInfo.arguments
        guard let i = args.firstIndex(of: "-tab"), i + 1 < args.count,
              let tab = DashboardTab(rawValue: args[i + 1]) else { return .plan }
        return tab
    }
}

@main
struct MigrationGateDemoApp: App {
    var body: some Scene {
        WindowGroup {
            MigrationDashboardView(policy: DemoConfiguration.gatePolicy, tab: DemoConfiguration.initialTab)
        }
    }
}
