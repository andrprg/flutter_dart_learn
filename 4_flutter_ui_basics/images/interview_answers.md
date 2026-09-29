# Ответы: Images

**1.** Asset из бандла; network грузит по URL (кэш в памяти/диске ограниченно).

**2.** cover — заполнить с обрезкой; contain — целиком без обрезки; fill — растянуть с искажением.

**3.** Placeholder на загрузке и UI ошибки вместо пустоты/краша.

**4.** Резервирует место, уменьшает layout jump до загрузки.

**5.** Пакет `cached_network_image` для дискового кэша; на собесе — упомянуть memory pressure.

**6.** `1.5x/2.0x/3.0x` папки; Flutter выбирает по devicePixelRatio.

**7.** Плавная смена placeholder → картинка.

**8.** `cacheWidth/cacheHeight`, сжатие, isolates для decode тяжёлого.
