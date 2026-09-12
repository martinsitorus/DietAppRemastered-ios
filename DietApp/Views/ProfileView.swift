import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [UserProfile]

    var isEditing: Bool = false

    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var age: String = ""
    @State private var gender: Gender = .male
    @State private var activity: ActivityLevel = .sedentary
    @State private var goal: WeightGoal = .maintain
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section("Body") {
                TextField("Weight (kg)", text: $weight)
                    .keyboardType(.decimalPad)
                TextField("Height (cm)", text: $height)
                    .keyboardType(.decimalPad)
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                Picker("Gender", selection: $gender) {
                    ForEach(Gender.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) }
                }
            }
            Section("Lifestyle") {
                Picker("Activity level", selection: $activity) {
                    ForEach(ActivityLevel.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                Picker("Target", selection: $goal) {
                    ForEach(WeightGoal.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
            }
            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            }
            Button("Save Profile") {
                guard let w = Double(weight), let h = Double(height), let a = Int(age),
                      w > 0, h > 0, a > 0 else {
                    errorMessage = "Please enter valid weight, height, and age."
                    return
                }
                let vm = UserProfileViewModel()
                vm.saveProfile(weightKg: w, heightCm: h, age: a, gender: gender, activity: activity, goal: goal, context: context)
                if isEditing { dismiss() }
            }
        }
        .navigationTitle(isEditing ? "Update Profile" : "Your Profile")
        .onAppear {
            if let existing = profiles.first {
                weight = String(existing.weightKg)
                height = String(existing.heightCm)
                age = String(existing.age)
                gender = existing.gender
                activity = existing.activityLevel
                goal = existing.weightGoal
            }
        }
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .modelContainer(for: [UserProfile.self], inMemory: true)
}
