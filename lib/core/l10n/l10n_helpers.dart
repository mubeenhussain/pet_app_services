import 'package:intl/intl.dart';
import 'package:pet_app/l10n/app_localizations.dart';
import 'package:pet_app/shared/enums/user_role.dart';

/// Shared formatting helpers for localized UI strings.
extension AppLocalizationsFormatters on AppLocalizations {
  String sarAmount(int amount) {
    final formatted = NumberFormat('#,###').format(amount);
    return sarAmountFormatted(formatted);
  }

  String ageLabel(int? age) {
    if (age == null) return '';
    if (age == 1) return ageYear(age);
    return ageYears(age);
  }

  String speciesLabel(String species) {
    final key = species.trim().toLowerCase();
    if (key.contains('cat')) return speciesCat;
    if (key.contains('bird')) return speciesBird;
    if (key.contains('other')) return speciesOther;
    return speciesDog;
  }

  String buyPetCategoryLabel(String categoryId) => switch (categoryId) {
        'dogs' => categoryDogs,
        'cats' => categoryCats,
        'birds' => categoryBirds,
        'horses' => categoryHorses,
        'camels' => categoryCamels,
        'adoption' => categoryAdoption,
        _ => categoryId,
      };

  String breedAgeLine(String breed, int ageYears) =>
      '$breed · ${ageLabel(ageYears)}';

  String userRoleLabel(UserRole role) => switch (role) {
        UserRole.petOwner => rolePetOwner,
        UserRole.seller => roleSeller,
        UserRole.provider => roleProvider,
        UserRole.houser => roleHouser,
        UserRole.clinic => roleClinic,
        UserRole.admin => adminDashboard,
      };
}
