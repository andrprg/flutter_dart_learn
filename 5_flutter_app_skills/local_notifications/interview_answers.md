# Ответы: Local Notifications

**1.** Local — устройство само показывает. Push — FCM/APNs с сервера.

**2.** С Android 8 канал определяет важность/звук; пользователь управляет в настройках.

**3.** Кнопки действий регистрируются в category; уведомление ссылается на categoryId.

**4.** Нужен runtime permission; иначе уведомления не видны.

**5.** Строка для навигации/id сущности при тапе/action.

**6.** На iOS настроить presentAlert/banner; на Android поведение канала/importance.

**7.** actionId пустой/null → tap; иначе id кнопки. Разный UX.

**8.** Один раз после binding; создать каналы до show; обработчики background/terminated отдельно продумать.
