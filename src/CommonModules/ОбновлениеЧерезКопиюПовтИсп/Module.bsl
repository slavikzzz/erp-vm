///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйИнтерфейс

// Возвращает признак использования Обновления через копию,
// в частности, надо ли регистрировать данные для отправки в корреспондента.
// 
// Возвращаемое значение:
//   Булево - Истина, если значение константы ОбновлениеЧерезКопиюСостояние равно
//                    Перечисления.СостоянияОбновлениеЧерезКопию.ВыгрузкаОбновлениеЧерезКопию.
//
Функция НужнаРегистрацияДанныхОбновленияЧерезКопию() Экспорт
	
	ТекущееСостояние = Константы.ОбновлениеЧерезКопиюСостояние.Получить();
	Возврат (ТекущееСостояние = Перечисления.СостоянияОбновлениеЧерезКопию.ВыгрузкаОбновлениеЧерезКопию);
	
КонецФункции

// Возвращает имя плана обмена, который используется для обновления через копию.
//
// Возвращаемое значение:
//   Строка - имя плана обмена, по-умолчанию "ОбновлениеЧерезКопию".
//
Функция ИмяПланаОбменаОбновления() Экспорт
	
	Возврат Метаданные.ПланыОбмена.ОбновлениеЧерезКопию.Имя;
	
КонецФункции

#КонецОбласти